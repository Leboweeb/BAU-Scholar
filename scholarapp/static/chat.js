let socket;

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
  let current_chat = document.querySelector("#current_chat");
  current_chat.innerHTML = selected_html;
}

function select_chat(node) {
  let other_chats = document.querySelectorAll(".contact");
  node.classList.add("selected");
  other_chats.forEach((value) => {
    if (value !== node) value.classList.remove("selected");
  });
  clearMessages();
  if (socket) {
    socket.close();
  }
  socket = createSocket();
  set_current_chat(node.dataset.name, node.dataset.avatar);
}

function add_conversation() {
  let messageInfo = getMessageInfo();
  let json = JSON.stringify({
    message: messageInfo.message,
    user_id_from: messageInfo.user_id_from,
    user_id_to: messageInfo.user_id_to,
  });
  if (socket.readyState === WebSocket.OPEN) {
    socket.send(json);
  }
}

function createSocket() {
  const messages = document.querySelector("#messages");
  let current_conversation = document.querySelector(".selected");
  let current_conversation_slug = current_conversation.dataset.conversation;
  const socket = new WebSocket(`/chat/${current_conversation_slug}`);
  socket.onopen = (ev) => {};

  socket.onmessage = (ev) => {
    let response = JSON.parse(ev.data);
    messages.appendChild(
      new DOMParser().parseFromString(response["message"], "text/html")
        .firstElementChild
    );
  };
  return socket;
}

function getMessageInfo() {
  return {
    user_id_from: document.querySelector("#user_id").dataset.user,
    user_id_to: document.querySelector(".selected").dataset.user,
    message: document.querySelector(".message-footer input:nth-child(1)").value,
  };
}

function clearMessages() {
  let element = document.querySelector("#messages");
  element.innerHTML = "";
}
