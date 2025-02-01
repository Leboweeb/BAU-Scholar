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

function displayChart() {
  new Chart(document.getElementById("myChart"), {
    type: "line",
    data: {
      labels: ["2020", "2021", "2022", "2023", "2024", "2025"],
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
          data: [801, 801, 801, 801, 711, 641],
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
          display: false,
        },
        tooltip: {
          enabled: false,
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
    const gradient = `background: conic-gradient(${ratingColor} ${ratingScore}%, transparent 0 100%)`;

    // Set the gradient as the rating background
    rating.setAttribute("style", gradient);

    // Wrap the content in a tag to show it above the pseudo element that masks the bar
    rating.innerHTML = `<span>${ratingScore} ${
      ratingContent.indexOf("%") >= 0 ? "<small>%</small>" : ""
    }</span>`;
  });
}
