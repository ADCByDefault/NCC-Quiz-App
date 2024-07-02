const questionElement = document.getElementById("question");
const answerAElement = document.getElementById("A");
const answerBElement = document.getElementById("B");
const answerCElement = document.getElementById("C");
const correctElement = document.getElementById("correct");
const info = document.getElementById("info");
const next = document.getElementById("next");
const answers = Array.from(document.getElementsByClassName("answer"));

let questions = [];
let reavealed = false;
let currentQuestion = {};

fetch("./data/data.json")
    .then((response) => {
        return response.json();
    })
    .then((data) => {
        questions = data;
        loadRandomQuestion();
    });

function loadRandomQuestion() {
    reavealed = false;
    const randomIndex = Math.floor(Math.random() * questions.length);
    currentQuestion = questions[randomIndex];
    console.log(currentQuestion);
    if (currentQuestion.forType != "autovetture") loadRandomQuestion();
    if (
        currentQuestion.type == "parte_tecnica" &&
        currentQuestion.provincia != "FIRENZE"
    )
        loadRandomQuestion();
    questionElement.innerText = currentQuestion["question"];
    answerAElement.innerText = currentQuestion["A"];
    answerBElement.innerText = currentQuestion["B"];
    answerCElement.innerText = currentQuestion["C"];
    correctElement.innerText = "";
}

function revealAnswer() {
    correctElement.innerText = currentQuestion["correct"];
    answers.forEach((answer) => {
        answer.classList.add("wrong");
    });
    const correct = document.getElementById(currentQuestion["correct"]);
    correct.classList.remove("wrong");
    correct.classList.add("correct");
    correctElement.innerText = currentQuestion["correct"];
}

next.addEventListener("click", () => {
    loadRandomQuestion();
    answers.forEach((answer) => {
        answer.classList.remove("correct");
        answer.classList.remove("wrong");
    });
});

answers.forEach((element) => {
    element.addEventListener("click", () => {
        revealAnswer();
    });
});
