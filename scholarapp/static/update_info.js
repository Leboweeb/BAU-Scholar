const update_profile_form = document.querySelector("#import-document");

// see https://stackoverflow.com/questions/15361189/how-to-select-all-other-values-in-an-array-except-the-ith-element
function exceptIndex(list, exceptIndex) {
  // ensure list is array
  return [...list].filter((value, index) => exceptIndex !== index);
}

function removeParent(elem) {
  elem.parentElement.remove();
}

function closePersonalInfoModal() {
  document.querySelector("#personalInfoModalClose").click();
}

function highlightDropArea(event) {
  event.preventDefault();
  dropArea.classList.add("drop-area-active");
}
function unhighlightDropArea(event) {
  event.preventDefault();
  dropArea.classList.remove("drop-area-active");
}

// see https://stackoverflow.com/questions/190852/how-can-i-get-file-extensions-with-javascript/12900504#12900504
function getExtension(fname) {
  return fname.slice(((fname.lastIndexOf(".") - 1) >>> 0) + 2);
}

function submitDocument(event) {
  // event.preventDefault();
  // event.dataTransfer.effectAllowed = "all";
  // event.dataTransfer.dropEffect = "copy";
  let fileInput = document.querySelector("#imported_document").files[0];
  if (getExtension(fileInput.name) !== "docx")
    alert("Please upload a valid docx file.");
  let formData = new FormData();
  formData.append("imported_document", fileInput);
  fetch("/update_profile", {
    method: "POST",
    headers: {
      "X-CSRFToken": csrf_token,
    },
    body: formData,
  })
    .then((response) => response.text())
    .then((text) => {
      htmx.swap(
        "#tags-skills-fragment",
        text,
        { swapStyle: "innerHTML" },
        {
          afterSwapCallback: () => {
            closePersonalInfoModal();
            unhighlightDropArea(event);
          },
        }
      );
    });
  // let formData = new FormData()
  // formData.append("")
  // update_profile_form.submit();
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

let dropArea = document.querySelector(".drop-area");

// dropArea
//   .addEventListener(
//     "dragstart",
//     (event) => {
//       event.dataTransfer.effectAllowed = "all";
//       event.dataTransfer.dropEffect = "move";
//     },
//     false
//   )

[("dragenter", "dragover")].forEach((eventName) => {
  dropArea.addEventListener(eventName, highlightDropArea, false);
});
["dragleave"].forEach((eventName) => {
  dropArea.addEventListener(eventName, unhighlightDropArea, false);
});

dropArea.addEventListener("drop", submitDocument, { capture: true });

let tabs = document.querySelectorAll(".nav.nav-underline button");
let contentDivs = document.querySelectorAll("#top-container >div");

function switchTabs(currentTabIndex) {
  let otherContent = exceptIndex(contentDivs, currentTabIndex);
  let otherButtons = exceptIndex(tabs, currentTabIndex);

  for (let index = 0; index < tabs.length; index++) {
    tabs[currentTabIndex].classList.add("active");
    contentDivs[currentTabIndex].classList.remove("d-none");
    otherContent.forEach((value) => value.classList.add("d-none"));
    otherButtons.forEach((value) => value.classList.remove("active"));
  }
}
