import os
from django.shortcuts import render, redirect
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from docx import Document
from PyPDF2 import PdfReader
from django.contrib.auth import authenticate, login
from sentence_transformers import SentenceTransformer, util
from django.contrib.auth.models import User
from django.contrib import messages
import re

model = SentenceTransformer('multi-qa-MiniLM-L6-cos-v1')
results_data = []



def home(request):
    return render(request, "home.html")


def extract_text(file):
    ext = os.path.splitext(file.name)[-1].lower()
    text = ""
    if ext == ".pdf":
        reader = PdfReader(file)
        for page in reader.pages:
            text += page.extract_text() or ""
    elif ext == ".docx":
        doc = Document(file)
        for para in doc.paragraphs:
            text += para.text + "\n"
    return text.strip()

def index(request):
    global results_data
    if request.method == "POST":
        job_description = request.POST.get("job_description", "")
        resumes = request.FILES.getlist("resumes")

        jd_embedding = model.encode(job_description, convert_to_tensor=True)
        scores = []

        for file in resumes:
            resume_text = extract_text(file)
            resume_embedding = model.encode(resume_text, convert_to_tensor=True)
            similarity_score = util.cos_sim(jd_embedding, resume_embedding).item() * 100
            scores.append((file.name, round(similarity_score, 2)))

        results_data = sorted(scores, key=lambda x: x[1], reverse=True)
        return redirect("results")

    return render(request, "index.html")

def results(request):
    ranked_results = [
        {'rank': idx + 1, 'name': r[0], 'score': r[1]}
        for idx, r in enumerate(results_data)
    ]
    return render(request, "results.html", {"results": ranked_results})