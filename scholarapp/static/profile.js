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
