from django.http import Http404, HttpResponse
from django.shortcuts import get_object_or_404, render

# from django.template import loader
from .models import Question


def index(request):
    latest_question_list = Question.objects.order_by("-pub_date")[:5]
    # output = ", ".join([q.question_text for q in latest_question_list])
    # template = loader.get_template("polls/index.html")
    context = {
        "latest_question_list": latest_question_list,
    }
    # return HttpResponse(output)
    # return HttpResponse(template.render(context, request))
    return render(request, "polls/index.html", context)


def detail(request, question_id):
    # response = f"You're looking at question {question_id}."
    # question = Question.objects.get(pk=question_id)
    question = get_object_or_404(Question, pk=question_id)
    return render(request, "polls/detail.html", {"question": question})


def results(request, question_id):
    response = f"You're looking at the results of question {question_id}."
    return HttpResponse(response)


def vote(request, question_id):
    response = f"You're voting on question {question_id}."
    return HttpResponse(response)
