const importControlller = new AbortController();

function submit_form(form) {
  const cardList = document.querySelector("#results");
  if (!cardList.children.length) return;
  else {
    let selectedCard = document.querySelector(".active");
    if (!selectedCard) {
      alert("Please provide a name to import from Research Gate.");
      return;
    }
    let cardJson = JSON.parse(selectedCard.dataset.profile);
    let inputNames = ["profile_url", "avatar"];
    let attrs = ["profile_page", "avatar"].map(
      (attr) => cardJson[attr] ?? null // this seems stupid but we want the server to actually understand that it is null. undefined is taken as a string.
    );
    // fuck you cloudflare, eat a dick
    try {
      if (typeof attrs[0] === "object") attrs[0] = attrs[0].join(",");
      attrs.forEach(
        (attr, index) =>
          (document.querySelector(`[name=${inputNames[index]}]`).value = attr)
      );
    } catch (e) {
      console.log(e);
    }
  }
  form.submit();
}

function add_card(profileJson) {
  let src = profileJson["avatar"];
  let name = profileJson["name"];
  const cardList = document.querySelector("#results");
  let node = new DOMParser().parseFromString(
    `
        <div class="col-12">
            <div class="card p-2 d-flex justify-items-center align-items-center flex-row gap-3 user-profile" onclick="card_active(event)" data-profile='${JSON.stringify(
              profileJson
            )}'>
                <img style="vertical-align: middle;width: 50px;height: 50px;border-radius: 50%;" src=${src}
                        alt="User Profile"
                        srcset="">
                <h5 style="line-height: 350%;">${name}</h5>
            </div>
        </div>
        `,
    "text/html"
  ).body.firstElementChild;
  node.addEventListener("click", event, true);
  cardList.appendChild(node);
}

function card_active(event) {
  let other_cards = document.querySelectorAll(".user-profile");
  let node =
    event.target.tagName === "DIV" ? event.target : event.target.parentElement;
  node.classList.add("active");
  other_cards.forEach((value) => {
    if (value !== node) value.classList.remove("active");
  });
}

function retryImport() {
  try {
    importControlller.abort(); // cancel any possible request
  } catch (error) {
    console.log(error);
  }
  import_if_name(); // then import again
}

function import_if_name() {
  const name = document.querySelector("#id_name").value || "";
  const myModal = new bootstrap.Modal("#exampleModal", {
    keyboard: false,
  });
  const cardList = document.querySelector("#results");
  const modalToggle = document.getElementById("#exampleModal");
  const importBackend = document.querySelector(
    'select[name="import_backend"]'
  ).value;
  if (name) {
    if (!cardList.children.length) {
      fetch("/import_user", {
        method: "POST",
        signal: importControlller.signal,
        body: JSON.stringify({
          name: name,
          backend: importBackend,
        }),
        headers: {
          "Content-type": "application/json; charset=UTF-8",
        },
      })
        .catch((e) => {
          console.log("Import canceled");
        })
        .then((response) => {
          document.querySelector("#loadingSpinner").classList.add("d-none");
          document.querySelector("input[name=import_backend]").value =
            importBackend;
          return response.json();
        })
        .then((json) => {
          for (const profile of json) {
            add_card(profile);
          }
        });
    }
    if (!document.querySelector(".modal-backdrop")) {
      myModal.show(modalToggle);
    }
  } else {
    alert("Please provide a valid name to import a profile.");
  }
}
