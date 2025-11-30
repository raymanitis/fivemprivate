function renderPlayerCard(player, config) {
  const { id, ping, name, jobName, jobLabel, jobOnDuty, isAdmin } = player;
  const whitelistJob = config.HighlightedJobs.find(({ jobs }) => jobs.includes(jobName));
  
  let pingClass = 'ping-medium';
  if (ping <= 50) pingClass = 'ping-low';
  else if (ping > 100) pingClass = 'ping-high';

  return `
    <div class="player-card">
      <div class="card-body">
        ${config.ShowPlayerIds ? `<div class="player-id">${id}</div>` : ""}
        <div class="player-details">
          <div class="player-name">${name}</div>
          <div class="player-accolades">
            ${config.ShowAdminBadges && isAdmin ? `<span class="badge"><i class="bi-${config.AdminBadgeIcon}"></i></span>` : ""}
            ${
              config.ShowPlayerJob
                ? `<span class="badge" ${whitelistJob ? `style="background-color: ${whitelistJob.color}20; border-color: ${whitelistJob.color}; color: ${whitelistJob.color}"` : ""}>
                    ${whitelistJob ? `<i class="bi-${whitelistJob.icon}"></i> ` : ""}
                    ${jobLabel} ${config.ShowPlayerJobDutyStatus && jobName !== "unemployed" ? (jobOnDuty ? "(on duty)" : "(off duty)") : ""}
                  </span>`
                : ""
            }
          </div>
        </div>
        ${config.ShowPing ? `
        <div class="player-ping ${pingClass}">
          <i class="bi-broadcast-pin"></i>
          <span>${ping}ms</span>
        </div>` : ""}
      </div>
    </div>
  `;
}

function showScoreboard(data) {
  const { config, maxSlots, players = [] } = data;

  // Header data
  document.querySelector("#server-title").innerHTML = config.ServerName;
  document.querySelector("#players-count").innerHTML = `${players.length}/${maxSlots}`;

  // Highlighted Jobs
  if (config.ShowHighlightedJobs) {
    let highlightedJobsHtml = "";
    for (let job of Object.values(config.HighlightedJobs).sort((a, b) => a.order - b.order)) {
      let { label, icon, color, count } = job;
      highlightedJobsHtml += `
        <div class="job-badge" style="background-color: ${color}20; border-color: ${color};">
          <i class="bi-${icon} job-icon" style="color: ${color};"></i>
          <span class="job-count">${count}</span>
          <span class="job-label">${label}</span>
        </div>
      `;
    }

    document.querySelector("#highlighted-jobs").innerHTML = highlightedJobsHtml;
  } else {
    document.querySelector("#highlighted-jobs").innerHTML = "";
  }

  // Current player
  let currentPlayerData = players.find(({ me }) => me);
  if (currentPlayerData) {
    document.querySelector("#current-player-data").innerHTML = renderPlayerCard(currentPlayerData, config);
  } else {
    document.querySelector("#current-player-data").innerHTML = "";
  }

  // All other players
  if (config.ShowPlayers) {
    let allPlayers = players.filter(({ me }) => !me);
    let allPlayersHtml = "";
    for (let player of allPlayers) {
      allPlayersHtml += renderPlayerCard(player, config);
    }

    document.querySelector("#all-players").innerHTML = allPlayersHtml || '<div class="no-players">No other players online.</div>';
  } else {
    document.querySelector("#all-players").innerHTML = "";
  }

  scoreboard.show();
}

function closeScoreboard() {
  scoreboard.hide();
}
