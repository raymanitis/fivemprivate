Config = Config or {}

Config.Locales = {
    shared = {
        allStagesCompleted = 'All Stages Completed!',
        stage = 'Stage',
        completed = 'Completed!',
        failed = 'Stage failed!',
    },
    aimIt = {
        instructions = 'Click on the targets to hit them!',
    },
    matchIt = {
        instructions = 'Rotate the circle to match incoming tile colors with the correct sectors!',
        controls = {
            rotate = 'Use A/D or ← → to rotate the circle',
        },
    },
    destroyLinks = {
        instructions = 'Press the correct arrow keys to destroy blocks from the bottom!',
    },
    electricalBox = {
        instructions = 'Toggle the breaker switches to restore power to the system!',
        sequenceLabel = 'SEQUENCE:',
        hiddenLabel = 'HIDDEN',
        targetLabel = 'TARGET:',
        stepLabel = 'STEP:',
        currentLabel = 'CURRENT:',
        offLabel = 'OFF',
        onLabel = 'ON',
    },
    cutIt = {
        instructions = 'Move the revealing tool SLOWLY to find marked cables, then cut them with the cutter tool! Moving too fast will prevent detection.',
    },
    reach = {
        instructions = 'Drag the circle from start (teal) to end (teal) without hitting walls. Limited visibility!',
    },
    pairs = {
        instructions = 'Find all matching pairs by clicking cards to flip them. Remember their positions!',
    },
    onTheDot = {
        instructions = 'Match falling ball colors with your deflectors - press SPACE to move side balls away!',
    },
    stickIt = {
        instructions = 'Shoot pins into the rotating circle without hitting existing pins. Click to shoot!',
    },
    sequence = {
        instructions = 'Find the sequence in the grid using arrow keys or WASD. Press Enter to select.',
        findSequenceLabel = 'Find this sequence:',
    },
    breachProtocol = {
        instructions = 'Find the target sequence in the security matrix. Navigate by alternating row and column selections.',
    },
    fingerprint = {
        instructions = 'Assemble the fingerprint by aligning all 5 parts correctly!',
    },
    pipePressure = {
        instructions = 'Click pipes to rotate them. Connect the flow from start to end.',
        startLabel = 'START',
        endLabel = 'END',
        flowInProgress = 'Flow in Progress...',
    },
    pathing = {
        instructions = 'Go to the next point closest point.',
    },
    aMess = {
        instructions = 'Make sure none of the lines intersect each other.',
    },
    getIt = {
        instructions = 'Use WASD or arrow keys to move the snake. Collect food to grow and complete each stage!',
    },
    dataStream = {
        instructions = 'Intercept the target packets as they flow through the network channels. Click to capture them and decrypt when prompted.',
        packetsRemaining = 'Targets Remaining:',
        mirrorPairsLabel = 'Mirror Pairs:',
        letterPositionsLabel = 'Letter Positions:',
        letterValuesLabel = 'Letter Values:',
        morseCodeLabel = 'Morse Code:',
        hexToBinaryLabel = 'Hex to Binary:',
        dot2x4SymbolsLabel = 'Dot 2x4 Symbols to Binary:',
        shapeSideSymbolsLabel = 'Shape Side Symbols:',
        dominoVerticalSymbolsLabel = 'Domino Vertical Symbols to Hex:',
        enterHex = 'Enter hex...',
        enterBinary = 'Enter binary...',
        enterDecryption = 'Enter decryption...',
        decryptButton = 'DECRYPT',
        decryptPattern = 'Decrypt the pattern',
    },
    echo = {
        instructions = 'Memorize the colored boxes, then answer how many of each color you saw',
        memorizePhase = 'Memorize the grid...',
        questionPhase = 'Answer the question:',
        howManyBoxes = 'How many {color} boxes were there?',
        answerKeys = 'Press 1, 2, or 3 to select your answer',
        getReadyMessage = 'Get ready to memorize...',
        colors = {
            red = 'Red',
            green = 'Green',
            blue = 'Blue',
            yellow = 'Yellow',
        },
    },
    unlocked = {
        instructions = 'Rotate dot circles one at a time to match colors with lines. A/D = rotate active circle, W = cycle circles, SPACE = check solution.',
    },
    numbers = {
        instructions = 'Click the numbers in ascending order (1, 2, 3, etc.) as fast as you can!',
    },
    mines = {
        instructions = 'Remember the mine positions, then find them all when they disappear!',
    },
    math = {
        instructions = 'Calculate both expressions mentally and compare: > (greater), < (less), or = (equal)',
        greater = 'Greater (>)',
        less = 'Less (<)',
        equal = 'Equal (=)',
    },
    keys = {
        instructions = 'Press the keys in the correct order from left to right, row by row!',
    },
    breaker = {
        instructions = 'Press SPACE or ENTER to launch the ball Use arrow keys or A/D to move the paddle',
        lives = 'Lives',
    },
    crackit = {
        instructions = 'Enter numbers to crack the PIN. Green = correct position, Yellow = wrong position, Red = not in PIN',
        crackButton = 'CRACK',
        deleteButton = 'DELETE',
    },
    dash = {
        instructions = 'Use A/D or Arrow Keys to move. Hit the green openings in the falling lines!',
    },
    flappy = {
        instructions = 'Press SPACE to flap your wings! Navigate through the horizontal pipes!',
        startMessage = 'Press SPACE or click to start!',
    },
    intime = {
        instructions = 'Press the letter or number keys to destroy falling blocks - destroy all blocks to progress!',
    },
    tothesky = {
        instructions = 'Use A/D or Arrow Keys to move left/right. Land on platforms to bounce higher! Reach the sky!',
    },
    towerofhanoi = {
        instructions = 'Move all disks to the rightmost tower. Only move one disk at a time. Cannot place larger disk on smaller disk.',
    },
    typix = {
        instructions = 'Guess the 5-letter word in 6 attempts. Green = correct position, Yellow = wrong position, Gray = not in word.',
        categoryLabel = 'Category',
        categories = {
            variety = 'Variety',
            animals = 'Animals',
            food = 'Food',
            tech = 'Tech',
            cities = 'Cities',
            countries = 'Countries',
            math = 'Math',
            tools = 'Tools',
            nsfw = 'NSFW',
        },
    },
    sequencememory = {
        instructions = 'Watch the sequence of highlighted boxes, then click them in the same order. Each round adds more boxes to remember.',
    },

    -- IveSeenIt Game
    IveSeenIt = {
        instructions = 'Click "Seen" if you\'ve seen this word before in this session, or "New" if it\'s the first time you see it.',
        seenButton = 'SEEN',
        newButton = 'NEW',
    },

    -- Game20471
    Game20471 = {
        instructions = 'Use WASD or arrow keys to slide tiles. Combine matching numbers to reach the target!',
        stageDescription = 'Combine tiles to reach {target}!',
    },

    -- Locked Game
    locked = {
        instructions = 'Rotate the arrow to find the correct section. Move slowly near targets to feel the lock.',
    },

    -- Balance Game
    balance = {
        instructions = 'Use Q and E to keep the needle balanced in the green zone. If it falls into the red zone, you fail! Survive for the full time to win.',
        controls = {
            left = 'Q - Push needle left',
            right = 'E - Push needle right',
        },
        failed = 'ASDFAILED!',
        success = 'SUCCESS!',
    },

}
