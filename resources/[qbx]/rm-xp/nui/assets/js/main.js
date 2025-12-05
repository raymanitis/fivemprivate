const Formats = {
    category: `
        <div class="skill-item" data-category="$[CATEGORY]">
            <div class="skill-header">
                <span class="skill-label">$[LABEL]</span>
                <div class="skill-level-info">
                    <span class="skill-level">Level $[LEVEL]</span>
                    <span class="skill-xp-text">$[XP] / $[LEVEL_XP] XP</span>
                </div>
            </div>
            <div class="progress-bar">
                <div class="progress-value" style="width: $[PROGRESS]%"></div>
            </div>
            <div class="skill-xp-details">
                <span>Progress: $[PROGRESS]%</span>
                <span>Remaining: $[REMAINING] XP</span>
            </div>
        </div>
    `,
}

let categories;
let currentCategory = 'all';

function post(type, data) {
    fetch(`https://pickle_xp/${type}`, {
        method: 'post',
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(data || {})
    })
    .then(response => {  })
    .catch(error => {  });
}

function getCategoryFromKey(key, categoryData) {
    // Use category from data if available
    if (categoryData && categoryData.category) {
        return categoryData.category.toLowerCase();
    }
    
    // Fallback: Check if key contains category name
    key = key.toLowerCase();
    if (key.includes('criminal')) return 'criminal';
    if (key.includes('civilian')) return 'civilian';
    if (key.includes('default')) return 'default';
    
    // Default fallback
    return 'default';
}

function filterSkills() {
    $('.skill-item').each(function() {
        const itemCategory = $(this).data('category');
        if (currentCategory === 'all' || itemCategory === currentCategory) {
            $(this).show();
        } else {
            $(this).hide();
        }
    });
}

function DisplayXP(data) {
    categories = data;
    let categoriesHtml = "";
    for (const [key, value] of Object.entries(categories)) {
        let category = value
        let xpHtml = Formats.category;
        let xp = (category.xp > category.level_xp ? category.level_xp : category.xp)
        let remaining = Math.max(0, category.level_xp - xp)
        let progress = Math.ceil((xp / category.level_xp) * 100)
        let categoryType = getCategoryFromKey(key, category);
        
        xpHtml = xpHtml.replaceAll("$[LABEL]", category.label)
        xpHtml = xpHtml.replaceAll("$[LEVEL]", category.level)
        xpHtml = xpHtml.replaceAll("$[XP]", xp.toLocaleString())
        xpHtml = xpHtml.replaceAll("$[LEVEL_XP]", category.level_xp.toLocaleString())
        xpHtml = xpHtml.replaceAll("$[PROGRESS]", progress)
        xpHtml = xpHtml.replaceAll("$[REMAINING]", remaining.toLocaleString())
        xpHtml = xpHtml.replaceAll("$[CATEGORY]", categoryType)
        categoriesHtml += xpHtml;
    }
    $("#middle").html(categoriesHtml);
    filterSkills();
    
    // Show with animation
    $("#container").css('display', 'flex');
    setTimeout(() => {
        $("#container").addClass('show');
    }, 10);
}

function HideSkills() {
    $("#container").removeClass('show');
    setTimeout(() => {
        $("#container").css('display', 'none');
    }, 300);
}

$(document).ready(function () {
    $(document).on("click", ".exit, .exit-wrapper", function(event) {
        event.stopPropagation();
        HideSkills()
        post("hide")
    })
    
    // Category button handlers
    $(document).on("click", ".category-btn", function() {
        $(".category-btn").removeClass("active");
        $(this).addClass("active");
        currentCategory = $(this).data("category");
        filterSkills();
    })
    
    // Handle ESC key to close menu
    $(document).on("keydown", function(event) {
        if (event.key === "Escape" || event.keyCode === 27) {
            HideSkills()
            post("hide")
        }
    })
})

window.addEventListener("message", function(ev) {
    var event = ev.data
    if (event.type == "show") {
        DisplayXP(event.data)
    }
    else if (event.type == "hide") {
        HideSkills()
    }
})
