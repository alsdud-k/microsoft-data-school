import json
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth import login, authenticate, logout
from django.contrib.auth.decorators import login_required
from .models import Task
from django.contrib.auth.forms import UserCreationForm, AuthenticationForm

# 회원가입
def signup_view(request):
    if request.method == "POST":
        form = UserCreationForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(request, user)
            return redirect('task_list')
    else:
        form = UserCreationForm()
    return render(request, 'todo/signup.html', {'form': form})

# 로그인
from django.contrib.auth.forms import AuthenticationForm

def login_view(request):
    if request.method == "POST":
        form = AuthenticationForm(data=request.POST)
        if form.is_valid():
            user = form.get_user()
            login(request, user)
            return redirect('task_list')
    else:
        form = AuthenticationForm()
    return render(request, 'todo/login.html', {'form': form})

# 로그아웃
def logout_view(request):
    logout(request)
    return redirect('login')

@login_required
def task_list(request):
    tasks = Task.objects.filter(user=request.user)
    return render(request, 'todo/task_list.html', {'tasks': tasks})

@login_required
def task_create(request):
    if request.method == "POST":
        title = request.POST.get("title")
        due_date = request.POST.get("due_date") or None
        Task.objects.create(user=request.user, title=title, due_date=due_date)
        return redirect("task_list")
    return render(request, "todo/task_create.html")

@login_required
def task_update(request, pk):
    task = get_object_or_404(Task, pk=pk, user=request.user)
    if request.method == "POST":
        task.title = request.POST['title']
        task.description = request.POST['description']
        task.completed = 'completed' in request.POST
        task.save()
        return redirect('task_list')
    return render(request, 'todo/task_form.html', {'task': task})

@login_required
def task_delete(request, pk):
    task = get_object_or_404(Task, pk=pk, user=request.user)
    task.delete()
    return redirect('task_list')

@login_required
def calendar_view(request):
    tasks = Task.objects.filter(user=request.user).exclude(due_date__isnull=True)

    events = [
        {
            "title": task.title,
            "start": task.due_date.isoformat(),
            "url": f"/update/{task.id}/"
        }
        for task in tasks
    ]

    events_json = json.dumps(events)

    return render(request, "todo/calendar.html", {"events_json": events_json})