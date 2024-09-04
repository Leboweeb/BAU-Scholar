const second_text = document.querySelector(".second-text");
const headingContainer = document.querySelector("#heading-container");
const postSignUpForm = document.querySelector("#form-container");
const topContainer = document.getElementById("top-container");
function showForm() {
  topContainer.classList.remove("vh-100");
  topContainer.classList.add("vh-75");
  if (headingContainer) {
    headingContainer.classList.add("d-none");
  }
  postSignUpForm.classList.remove("d-none");
}

function removeParent(elem) {
  elem.parentElement.remove();
}

function addInput(parentId) {
  let parent = document.querySelector(`#div_id_${parentId} > .row`);
  let input_group = document.createElement("div");
  let remove_button = document.createElement("button");
  let remove_svg = new DOMParser().parseFromString(
    `
                <svg xmlns="http://www.w3.org/2000/svg"
                     width="16"
                     height="16"
                     fill="currentColor"
                     class="bi bi-trash"
                     viewBox="0 0 16 16">
                    <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0z" />
                    <path d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4zM2.5 3h11V2h-11z" />
                </svg>
    `,
    "text/html"
  ).body.firstElementChild;
  input_group.className = "input-group mb-3";
  remove_button.className = "btn btn-secondary row-remove";
  remove_button.type = "button";
  remove_button.onclick = () => {
    removeParent(remove_button);
  };
  remove_button.appendChild(remove_svg);
  let newField = document.createElement("input");
  newField.setAttribute("type", "text");
  newField.setAttribute("name", `${parentId}`);
  newField.setAttribute("class", "textinput form-control");
  input_group.appendChild(newField);
  input_group.appendChild(remove_button);
  parent.appendChild(input_group);
}

document.querySelectorAll(".dynamic-form").forEach((elem) => {
  let parendId = elem.parentElement.parentElement.id.replace("div_id_", "");
  elem.addEventListener("click", () => {
    addInput(parendId);
  });
});

document.querySelectorAll(".row-remove").forEach((elem) => {
  elem.addEventListener("click", () => {
    removeParent(elem);
  });
});

if (second_text) {
  second_text.addEventListener("animationend", showForm);
} else {
  showForm();
}
