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

function downloadCV(filename) {
  let b64String;
  fetch("/generate_user_cv", {
    method: "POST",
    headers: { "X-CSRFToken": `${csrf_token}` },
  })
    .then((response) => response.json())
    .then((json) => (b64String = json["data"]));
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
}
