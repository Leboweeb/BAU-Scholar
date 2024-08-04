function add_profile(name) {
  const contacts = document.querySelector("#contacts");
  if (!document.querySelector(`.contact[data-name="${name}"]`)) {
    let node = new DOMParser().parseFromString(
      `
            <li class="list-group-item contact" data-name="${name}">
                <div class="d-flex flex-row gap-2">
                    <a href="javascript:void(0)">
                        <img class="avatar avatar-48 bg-light rounded-circle text-white p-1"
                                src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='currentColor' class='bi bi-person-fill' viewBox='0 0 16 16'%3E%3Cpath d='M3 14s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1zm5-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6'/%3E%3C/svg%3E"
                                alt="User Image">
                    </a>
                    <p  style="line-height: 300%;">${name}</p>
                </div>
            </li>
    `,
      "text/html"
    ).body.firstElementChild;
    node.onclick = function () {
      select_chat(node);
    };
    contacts.appendChild(node);
  }
  set_current_chat(name);
}

function show_chatbox() {
  document.querySelector("#chat-box").classList.remove("d-none");
}

function set_current_chat(name) {
  let selected_html = new DOMParser().parseFromString(
    `
                <a href="">
                    <img class="avatar avatar-48 bg-light rounded-circle text-white p-1"
                         src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='currentColor' class='bi bi-person-fill' viewBox='0 0 16 16'%3E%3Cpath d='M3 14s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1zm5-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6'/%3E%3C/svg%3E"
                         alt="User Profile" />
                </a>
                <!-- Needs to be 15 characters -->
                <p style="line-height: 300%;">${name}</p>
  `,
    "text/html"
  ).body.childNodes;
  let current_chat = document.querySelector("#current_chat");
  if (!current_chat.childElementCount) current_chat.append(...selected_html);
}

function select_chat(node) {
  let other_chats = document.querySelectorAll(".contact");
  node.classList.add("selected");
  other_chats.forEach((value) => {
    if (value !== node) value.classList.remove("selected");
  });
  set_current_chat(node.dataset.name);
}
