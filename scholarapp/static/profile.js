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

function checkAuthorSelected() {
  if (!hidden_author_field.value) {
    alert("Please Select at least one author for this event.");
    return false;
  }
  return true;
}
