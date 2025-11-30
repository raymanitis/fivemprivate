let scoreboard = {
  element: null,
  show: function() {
    if (this.element) {
      this.element.classList.add('show');
    }
  },
  hide: function() {
    if (this.element) {
      this.element.classList.remove('show');
      closeNUI();
    }
  }
};

async function closeNUI() {
  await fetch(`https://jg-scoreboard/close`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json; charset=UTF-8",
    },
  });
}

function main() {
  window.addEventListener("message", ({ data }) => {
    switch (data.type) {
      case "showScoreboard":
        showScoreboard(data.data);
        break;
      case "closeScoreboard":
        closeScoreboard();
        break;
      default:
        break;
    }
  });

  // Handle ESC key to close scoreboard
  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape" && scoreboard.element && scoreboard.element.classList.contains('show')) {
      closeScoreboard();
    }
  });

  scoreboard.element = document.getElementById("scoreboard-wrapper");
}

main();
