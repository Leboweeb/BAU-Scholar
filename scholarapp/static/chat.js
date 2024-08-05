function add_profile(contact) {
  let name = contact["name"];
  let avatar = contact["avatar"];
  const contacts = document.querySelector("#contacts");
  if (!document.querySelector(`.contact[data-name="${name}"]`)) {
    let node = new DOMParser().parseFromString(
      `
            <li class="list-group-item contact" data-name="${name}" data-avatar="${avatar}">
                <div class="d-flex flex-row gap-2">
                    <a href="javascript:void(0)">
                        <img class="avatar avatar-48 bg-light rounded-circle text-white p-1"
                                src="${avatar}"
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
  set_current_chat(name, avatar);
}

function show_chatbox() {
  document.querySelector("#chat-box").classList.remove("d-none");
}

function set_current_chat(name, avatar) {
  let selected_html = `
                <a href="">
                    <img class="avatar avatar-48 bg-light rounded-circle text-white p-1"
                         src="${avatar}"
                         alt="User Profile" />
                </a>
                <!-- Needs to be 15 characters -->
                <p style="line-height: 300%;">${name}</p>
  `;
  const messages = document.querySelector("#messages");
  let current_chat = document.querySelector("#current_chat");
  let current_conversation_slug =
    document.querySelector(".selected").dataset.conversation;
  messages.setAttribute("hx-ws", `connect:/chat/${current_conversation_slug}`);
  htmx.process(messages);
  current_chat.innerHTML = selected_html;
}

function select_chat(node) {
  let other_chats = document.querySelectorAll(".contact");
  node.classList.add("selected");
  other_chats.forEach((value) => {
    if (value !== node) value.classList.remove("selected");
  });
  set_current_chat(node.dataset.name, node.dataset.avatar);
}
