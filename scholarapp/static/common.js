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
  let list = listString.split(",");
  let numberSet = new Set(list);
  callback(numberSet, element);
  return [...numberSet].join(",");
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

function submitForm(preSubmitCallback, formSelector) {
  preSubmitCallback();
  let form = document.querySelector(formSelector);
  form.submit();
}
