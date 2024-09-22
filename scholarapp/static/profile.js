function toggleEdit() {
  event.preventDefault();
  document.querySelectorAll(".form-hidden").forEach((elem) => {
    elem.classList.toggle("d-none");
  });
}

function uploadPicture() {
  // event.stopPropagation();
  // event.preventDefault();
  var input = document.querySelector("#profilePicture");
  input.onchange = function () {
    let formData = new FormData();
    formData.append("file", input.files[0]);
    fetch("/update_profile", {
      method: "POST",
      body: formData,
      headers: { "X-CSRFToken": `${csrf_token}` },
    });
  };
  input.click();
}

function downloadDocument(filename) {
  let selectedDocument = document.querySelector("#documentSelector").value;
  if (selectedDocument === "Select Personal Document to Download") {
    return;
  }
  let b64String;
  fetch("/generate_user_cv", {
    body: JSON.stringify({
      selected_document: selectedDocument,
      user_id: user_id,
    }),
    method: "POST",
    headers: {
      "X-CSRFToken": `${csrf_token}`,
      "Content-Type": "application/json",
    },
  })
    .then((response) => response.json())
    .then((json) => {
      b64String = json["data"];
      var element = document.createElement("a");
      element.setAttribute(
        "href",
        "data:application/octet-stream;base64," + b64String
      );
      element.setAttribute("download", `${filename}.docx`);

      element.style.display = "none";
      document.body.appendChild(element);
      element.click();
      document.body.removeChild(element);
    });
}

let dropDown = document.querySelector("#customDropdown");
let badges = document.querySelector("#badges");
let hidden_author_field = document.querySelector("#authors_field");

function showDropDown() {
  dropDown.classList.remove("d-none");
}

function hideDropDown() {
  let search = document.querySelector("#author_search");
  search.value = "";
  dropDown.classList.add("d-none");
}

function checkAuthorSelected() {
  if (!hidden_author_field.value) {
    alert("Please Select at least one author for this event.");
  }
  return;
}

function appendSVG(node, svg) {
  let svgNode = new DOMParser().parseFromString(svg, "text/html").body
    .firstElementChild;
  svgNode.onclick = (event) => {
    let parentElement = event.currentTarget.parentElement;
    hidden_author_field.value = removeFromListString(
      hidden_author_field.value,
      parentElement.dataset.user
    );
    parentElement.remove();
  };
  node.appendChild(svgNode);
}

function addPill(event, name, user) {
  // prevent dupes
  if (document.querySelector(`span[ data-user="${user}" ]`)) return;
  event.currentTarget.classList.add("selected");
  let pill = document.createElement("span");
  pill.className = "badge rounded-pill bg-secondary w-fit-content";
  pill.dataset.user = user;
  pill.textContent = name;
  appendSVG(
    pill,
    `
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-x cursor-pointer" viewBox="0 0 16 16">
  <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708"/>
</svg>
    `
  );
  hidden_author_field.value = appendToListString(
    hidden_author_field.value,
    user
  );
  badges.appendChild(pill);
}
