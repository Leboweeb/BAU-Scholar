const update_profile_form = document.querySelector("#import-document");
const pathSeperators = /[\\/]/;

function removeParent(event) {
  event.currentTarget.parentElement.remove();
}

function closePersonalInfoModal() {
  document.body.classList.remove("modal-open");
  document.body.style = "";
  document.querySelector(".modal-backdrop").remove();
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

function submitDocument(event) {
  event.preventDefault();
  // event.dataTransfer.effectAllowed = "all";
  // event.dataTransfer.dropEffect = "copy";
  let fileInput = document.querySelector("#imported_document").files[0];
  if (getExtension(fileInput.name) !== "docx")
    alert("Please upload a valid docx file.");
  let formData = new FormData();
  let target = "#personalInfoForm";
  let swapStyle = "outerHTML";
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
        target,
        text,
        { swapStyle: swapStyle },
        {
          afterSwapCallback: () => {
            add_event_listeners();
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
  remove_button.onclick = (event) => {
    removeParent(event);
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

let dropArea = document.querySelector(".drop-area");

[("dragenter", "dragover")].forEach((eventName) => {
  dropArea.addEventListener(eventName, highlightDropArea, false);
});
["dragleave"].forEach((eventName) => {
  dropArea.addEventListener(eventName, unhighlightDropArea, false);
});

dropArea.addEventListener("drop", submitDocument, { capture: true });

function add_event_listeners() {
  let department_select = document.querySelector("#div_id_department select");
  let tags = document.querySelector("#div_id_tags input");
  tags.setAttribute("hx-vals", `js:{...getTagParams()}`);
  htmx.process(tags);
  department_select.onclick = swapProgramSelect;
}

add_event_listeners();

function getTagParams() {
  let department_select = document.querySelector("#div_id_department select");
  let department = department_select.value;
  let program = document.querySelector("#div_id_program select").value;
  return { department, program };
}

function swapProgramSelect(event) {
  let department = event.currentTarget.value;
  htmx.ajax("POST", "/swap_program", {
    target: 'select[name="program "]',
    swap: "outerHTML",
    values: { department: department },
  });
}
