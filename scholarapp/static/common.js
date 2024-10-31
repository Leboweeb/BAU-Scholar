// see https://stackoverflow.com/questions/15361189/how-to-select-all-other-values-in-an-array-except-the-ith-element
function exceptIndex(list, exceptIndex) {
  // ensure list is array
  return [...list].filter((value, index) => exceptIndex !== index);
}

function indexFromSelector(selector, node) {
  let nodelist = document.querySelectorAll(selector);
  return [...nodelist].indexOf(node);
}

// see https://stackoverflow.com/questions/190852/how-can-i-get-file-extensions-with-javascript/12900504#12900504
function getExtension(fname) {
  return fname.slice(((fname.lastIndexOf(".") - 1) >>> 0) + 2);
}

function splitAtDot(string) {
  return string.split("•");
}

function switchTabs(tabsSelector, contentDivsSelector, currentTabIndex) {
  let tabs = document.querySelectorAll(tabsSelector);
  let contentDivs = document.querySelectorAll(contentDivsSelector);
  let otherContent = exceptIndex(contentDivs, currentTabIndex);
  let otherButtons = exceptIndex(tabs, currentTabIndex);

  for (let index = 0; index < tabs.length; index++) {
    tabs[currentTabIndex].classList.add("active");
    contentDivs[currentTabIndex].classList.remove("d-none");
    otherContent.forEach((value) => value.classList.add("d-none"));
    otherButtons.forEach((value) => value.classList.remove("active"));
  }
}

function toggleActive(contentSelector, activeClassName, index) {
  let content = document.querySelectorAll(contentSelector);
  content[index].classList.add(activeClassName);
  exceptIndex(content, index).forEach((elem) => {
    elem.classList.remove(activeClassName);
  });
}

function ListStringOperation(listString, element, callback) {
  if (!listString) {
    return element;
  }
  let list = listString.split("•");
  let numberSet = new Set(list);
  callback(numberSet, element);
  return [...numberSet].join("•");
}

let appendToListString = (listString, element) => {
  return ListStringOperation(listString, element, (set, _) => {
    set.add(element);
  });
};

let removeFromListString = (listString, element) => {
  return ListStringOperation(listString, element, (set, _) => {
    set.delete(element);
  });
};

function submitForm(validatorCallback, formSelector) {
  let result = validatorCallback();
  if (!result) {
    return;
  }
  let form = document.querySelector(formSelector);
  form.submit();
}

function showDropDown(selector) {
  let dropDown = document.querySelector(selector);
  dropDown.classList.remove("d-none");
}

function hideDropDown(selector) {
  let dropDown = document.querySelector(selector);
  let search = document
    .querySelector(selector)
    .parentElement.querySelector("input:nth-child(2)");
  search.value = "";
  dropDown.classList.add("d-none");
}

function removePill(event, data_attr) {
  let top_element =
    event.currentTarget.parentElement.parentElement.parentElement;
  let hidden_input_node = top_element.querySelector("input[type='hidden']");
  let parentElement = event.currentTarget.parentElement;
  hidden_input_node.value = removeFromListString(
    hidden_input_node.value,
    parentElement.dataset[data_attr]
  );
  parentElement.remove();
}

function appendSVG(node, svg, hidden_input_node, data_attr) {
  let svgNode = new DOMParser().parseFromString(svg, "text/html").body
    .firstElementChild;
  svgNode.onclick = (event) => {
    let parentElement = event.currentTarget.parentElement;
    hidden_input_node.value = removeFromListString(
      hidden_input_node.value,
      parentElement.dataset[data_attr]
    );
    parentElement.remove();
  };
  node.appendChild(svgNode);
}

/*
  Adds a pill representing the choice the user selected. Note that the badges section must have the class .badges
  @param {string} name - The choice the user selected.
  @param {string} hidden_input - The selector for the hidden input.
  @param {string} attribute - A unique attribute name for the hidden input to use.
  @param {string} hidden_input - The value for this attribute at this specific pill.
*/
function addPill(event, name, attribute, value, top_element_node = undefined) {
  let top_element = top_element_node
    ? top_element_node
    : event?.currentTarget?.parentElement?.parentElement?.parentElement;
  let hidden_input_node = top_element.querySelector("input[type='hidden']");
  // prevent dupes
  if (top_element.querySelector(`span[ data-${attribute}="${value}" ]`)) return;
  let pill = document.createElement("span");
  pill.className = "badge rounded-pill bg-secondary w-fit-content";
  pill.dataset[attribute] = value;
  pill.textContent = name;
  appendSVG(
    pill,
    `
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-x cursor-pointer" viewBox="0 0 16 16">
  <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708"/>
</svg>
    `,
    hidden_input_node,
    attribute
  );
  hidden_input_node.value = appendToListString(hidden_input_node.value, value);
  let badges_section = hidden_input_node.parentElement.querySelector(".badges");
  badges_section.appendChild(pill);
}

// see https://stackoverflow.com/questions/196972/convert-string-to-title-case-with-javascript
function toTitleCase(str) {
  return str.replace(
    /\w\S*/g,
    (text) => text.charAt(0).toUpperCase() + text.substring(1).toLowerCase()
  );
}

// see https://stackoverflow.com/questions/951021/what-is-the-javascript-version-of-sleep
function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function closeToggleModal() {
  // very ugly hack incoming
  await sleep(350);
  document.body.classList.remove("modal-open");
  document.querySelector(".modal-backdrop").remove();
  document.body.style = "";
}

function populateAutoCompleteInput(inputNode, attr, values) {
  for (let element of values) {
    addPill(event, element, attr, element, inputNode.parentElement);
  }
}
