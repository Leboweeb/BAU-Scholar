let statisticsData;

// fetch admin data on start

function toggleElementClass(node, classParam) {
  node.classList.toggle(classParam);
}

let toggleElement = (node) => toggleElementClass(node, "d-none");

function toggleSideBar() {
  document.querySelector(".sidebar").classList.toggle("sidebar-collapsed");
  document.querySelectorAll("hr").forEach((val) => toggleElement(val));
  document
    .querySelectorAll(".sidebar-tab")
    .forEach((val) => toggleElementClass(val, "collapsed-tabs"));
  toggleElement(document.querySelector(".user-name"));
  let dashboard_header = document.querySelector(".dashboard-header");
  toggleElement(dashboard_header);
  toggleElement(dashboard_header.previousElementSibling);
}

function displayBarChart() {
  let graphData = JSON.parse(
    document.getElementById("faculty-counts").textContent
  );
  new Chart(document.getElementById("faculty-chart"), {
    type: "bar",
    data: {
      labels: graphData["x"],
      options: {
        plugins: {
          legend: {
            display: false,
          },
          tooltip: {
            enabled: false,
          },
        },
      },
      datasets: [
        {
          data: graphData["y"],
          label: "Research Papers",
        },
      ],
    },

    options: {
      scales: {
        y: {
          reverse: false,
        },
      },
      plugins: {
        title: {
          display: true,
          text: "BAU Research Papers by Faculty (2025)",
        },
        legend: {
          display: false,
        },
        tooltip: {
          enabled: true,
        },
      },
    },
  });
}

function displayLineGraph() {
  let graphData = JSON.parse(document.getElementById("graph-data").textContent);
  new Chart(document.getElementById("myChart"), {
    type: "line",
    data: {
      labels: graphData["x"],
      options: {
        plugins: {
          legend: {
            display: false,
          },
          tooltip: {
            enabled: false,
          },
        },
      },
      datasets: [
        {
          data: graphData["y"],
          label: "Rankings",
        },
      ],
    },

    options: {
      scales: {
        y: {
          reverse: true,
        },
      },
      plugins: {
        title: {
          display: true,
          text: "BAU Rankings 2020-2025",
        },
        legend: {
          display: true,
        },
        tooltip: {
          enabled: true,
        },
      },
    },
  });
}

function displayProgressCircles() {
  // based on this codepen https://codepen.io/leandroamato/pen/jOWqrGe
  const ratings = document.querySelectorAll(".rating");

  // Iterate over all rating items
  ratings.forEach((rating) => {
    // Get content and get score as an int
    const ratingContent = rating.innerHTML;
    const ratingScore = parseInt(ratingContent, 10);
    // After adding the class, get its color
    const ratingColor = window.getComputedStyle(rating).backgroundColor;
    // Define the background gradient according to the score and color
    const gradient = `background: conic-gradient(${ratingColor} ${ratingScore}%, lightgrey 0 100%)`;

    // Set the gradient as the rating background
    rating.setAttribute("style", gradient);

    // Wrap the content in a tag to show it above the pseudo element that masks the bar
    rating.innerHTML = `<span>${ratingScore} ${
      ratingContent.indexOf("%") >= 0 ? "<small>%</small>" : ""
    }</span>`;
  });
}

function populateDepartment() {
  let selector = "#faculty";
  let currentFaculty = document.querySelector(selector).value;
  if (!currentFaculty) {
    return;
  }
  populateDepartmentSelect(currentFaculty, "#department");
}

function downloadReport(event) {
  event.preventDefault();
  let form = document.getElementById("facultyReportForm");
  let b64String;
  fetch("/generate_report", {
    method: "post",
    headers: {
      "X-CSRFToken": `${csrf_token}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify(Object.fromEntries(new FormData(form))),
  })
    .then((response) => response.json())
    .then((json) => {
      b64String = json["data"];
      downloadBase64(b64String, "Faculty Report");
    });
}

function resizeSideBar() {
  let navbar = document.getElementById("navbar-top");
  let profilePicture = document.getElementById("profile-picture");
  let sidebar = document.getElementById("sidebar-wrapper");
  let navRect = navbar.getBoundingClientRect();
  let top = navRect.height + navRect.top;
  if (top > 0) {
    sidebar.style.top = `${top}px`;
    profilePicture.style.bottom = `${top}px`;
  } else {
    sidebar.style.top = "0px";
    profilePicture.style.bottom = "0px";
  }
}
