Config = Config or {}

Config.IveSeenIt = {
    description =
    'Test your memory by identifying whether you\'ve seen words before! Click "Seen" if you\'ve seen the word before in this session, or "New" if it\'s the first time you see it.',
    numberOfStages = 3,    -- Total stages to complete
    wordsPerStage = 20,    -- Words per stage
    timePerStage = 18,     -- Time per stage in seconds
    repeatWordChance = 50, -- Chance of word repeat percentage
    wordList = {           -- A list with words
        -- 3-letter words
        'cat', 'dog', 'run', 'car', 'sun', 'boy', 'man', 'can', 'get',
        'new', 'old', 'big', 'red', 'hot', 'you', 'yes', 'now', 'way',
        'may', 'say', 'she', 'her', 'him', 'his', 'how', 'who', 'why', 'try',
        'buy', 'fly', 'cry', 'dry', 'sky', 'eye', 'cut', 'put', 'sit', 'hit',
        'bit', 'fit', 'win', 'fun', 'gun', 'cup', 'map', 'top', 'box', 'fox',
        'mix', 'fix', 'six', 'tax', 'wax', 'max', 'war', 'far', 'bar', 'jar',
        'tar', 'air', 'sea', 'tea', 'bee', 'see', 'day', 'pay', 'lay', 'bay',
        -- 4-letter words
        'girl', 'cold', 'tree', 'free', 'play', 'stay', 'away', 'gray', 'pray', 'clay',
        'home', 'love', 'life', 'time', 'work', 'good', 'long', 'help', 'know', 'come',
        'want', 'need', 'make', 'take', 'give', 'look', 'find', 'tell', 'keep', 'feel',
        'show', 'hand', 'head', 'book', 'word', 'door', 'room', 'food', 'back', 'face',
        'name', 'game', 'each', 'team', 'idea', 'area', 'week', 'year', 'city', 'deal',
        'fire', 'warm', 'cool', 'real', 'move', 'turn', 'open', 'walk', 'talk',
        'call', 'fall', 'wall', 'ball', 'tall', 'mall', 'hall', 'pull', 'push', 'rush',
        'blue', 'true', 'sure', 'pure', 'cure', 'late', 'date', 'gate', 'hate', 'rate',
        'fast', 'past', 'last', 'cast', 'vast', 'best', 'test', 'rest', 'west', 'nest',
        'mind', 'kind', 'find', 'wind', 'wild', 'mild', 'bold', 'cold', 'gold', 'hold',
        'fold', 'told', 'sold', 'role', 'hole', 'pole', 'sole', 'bone', 'tone', 'zone',
        -- 5-letter words
        'close', 'world', 'house', 'study', 'learn', 'happy', 'money', 'group', 'story', 'right', 'water',
        'light', 'night', 'might', 'sight', 'fight', 'tight', 'white', 'black', 'green', 'brown',
        'place', 'space', 'peace', 'piece', 'voice', 'point', 'sound', 'round', 'found', 'ground',
        'under', 'after', 'never', 'every', 'other', 'power', 'paper', 'music', 'build', 'stand',
        'start', 'heart', 'party', 'early', 'ready', 'heavy', 'quick', 'thick', 'clean', 'clear',
        'price', 'drive', 'above', 'below', 'check', 'chair', 'table', 'phone', 'mouse', 'horse', 'nurse', 'shirt', 'short', 'sport', 'smart', 'small', 'smile', 'smoke',
        'snake', 'shake', 'shape', 'share', 'sharp', 'sheep', 'shell', 'shift', 'shine', 'shock',
        'shoot', 'shore', 'shout', 'since', 'skill', 'sleep', 'slide',
        'solid', 'solve', 'sorry', 'south', 'speak', 'speed', 'apple', 'grape', 'peach', 'mango', 'lemon', 'melon', 'onion', 'pizza', 'pasta', 'salad', 'bread', 'honey', 'sugar',
        -- 6-letter words
        'should', 'friend', 'family', 'mother', 'father', 'sister', 'brother', 'coffee', 'orange', 'yellow', 'purple',
        'simple', 'middle', 'office', 'market', 'moment', 'number', 'answer', 'listen', 'person', 'reason',
        'season', 'letter', 'better', 'matter', 'gather', 'rather', 'either', 'master', 'finger',
        'winter', 'summer', 'spring', 'change', 'chance', 'choice', 'church', 'center', 'circle', 'second',
        'school', 'street', 'strong', 'single', 'double', 'triple', 'temple', 'sample',
        'battle', 'bottle', 'castle', 'cattle', 'settle', 'little', 'button', 'cotton', 'kitten', 'mitten',
        'garden', 'golden', 'hidden', 'sudden', 'wooden', 'broken', 'frozen', 'happen', 'island', 'banana',
        'animal', 'become', 'before', 'belong', 'beside', 'bridge', 'bright', 'bronze', 'camera', 'cancer',
        'candle', 'cannot', 'canvas', 'carbon', 'career', 'caught', 'charge', 'cheese', 'cherry', 'choose',
        'client', 'closer', 'colony', 'combat', 'carrot', 'potato', 'tomato', 'rocket', 'planet', 'galaxy', 'energy', 'magnet', 'frozen', 'golden', 'silver', 'copper', 'bronze',
        'artist', 'writer', 'doctor', 'lawyer', 'worker', 'player', 'singer', 'dancer', 'button', 'window', 'mirror', 'carpet', 'pillow', 'drawer', 'handle', 'pocket', 'wallet',
        'pencil', 'marker', 'eraser', 'folder', 'binder', 'island', 'forest', 'desert', 'bridge', 'tunnel', 'engine', 'ladder', 'hammer', 'garden', 'flower', 'branch', 'shadow',
        'candle', 'flower', 'shower', 'powder', 'butter', 'cheese', 'pepper', 'pickle', 'jacket', 'helmet', 'gloves', 'shorts',
        -- 7-letter words
        'teacher', 'student', 'college', 'company', 'country', 'kitchen', 'bedroom', 'chicken', 'problem', 'station', 'machine', 'freedom',
        'reading', 'writing', 'walking', 'talking', 'working', 'cooking', 'looking', 'parking', 'banking', 'ranking',
        'package', 'message', 'passage', 'village', 'storage', 'cottage', 'cabbage', 'baggage', 'luggage', 'courage',
        'amazing', 'morning', 'evening', 'nothing', 'someone', 'anymore', 'anybody', 'another', 'between', 'because',
        'without', 'through', 'thought', 'brought', 'tonight', 'herself', 'himself', 'outside', 'instead',
        'picture', 'weather', 'meeting', 'feeling', 'setting', 'getting',
        'letting', 'putting', 'cutting', 'sitting', 'hitting', 'fitting', 'betting', 'wedding', 'bedding', 'heading',
        'leading', 'feeding', 'needing', 'seeding', 'weeding', 'holding', 'folding', 'molding', 'scolding',
        'dancing', 'advance', 'balance', 'finance', 'romance', 'surface',
        'voltage', 'hostage', 'sausage', 'garbage', 'blanket', 'stapler', 'printer', 'scanner', 'camera', 'speaker',
        'sweater',
        -- 8-letter words
        'prancing', 'glancing', 'computer', 'keyboard', 'football', 'baseball', 'birthday', 'sandwich', 'hospital', 'building', 'teaching', 'learning',
        'swimming', 'shopping', 'climbing', 'drinking', 'thinking', 'blinking', 'sinking', 'linking', 'bringing', 'swinging',
        'ringing', 'singing', 'dancing', 'romancing', 'enhancing', 'advancing', 'balancing', 'financing',
        'creating', 'relating', 'debating', 'locating', 'donating', 'rotating', 'floating', 'coating', 'boating', 'noting',
        'quoting', 'voting', 'doting', 'promoting', 'demoting', 'devoting', 'exploding', 'imploding', 'encoding', 'decoding',
        'somebody', 'everybody', 'anything', 'language', 'wordplay', 'weekday', 'highway', 'pathway', 'railway', 'gateway', 'halfway',
        'heritage', 'coverage', 'shortage', 'mortgage', 'footage', 'printing', 'painting', 'pointing', 'mounting', 'counting', 'hunting', 'wanting', 'planting', 'granting',
        'ranting',
        'mountain', 'toolbox',
        -- 9-letter words
        'something', 'everybody', 'somewhere', 'beautiful', 'wonderful', 'important', 'different', 'available', 'community', 'education', 'knowledge', 'certainly', 'completely',
        'obviously', 'seriously', 'basically', 'perfectly', 'naturally', 'generally', 'typically', 'currently', 'recently', 'probably',
        'hopefully', 'carefully', 'extremely', 'absolutely', 'definitely', 'apparently', 'fortunately', 'gradually', 'eventually', 'frequently', 'constantly',
        'basketball', 'volleyball', 'chocolate', 'newspaper', 'telephone', 'butterfly', 'sunflower', 'blueberry', 'strawberry',
        'workplace', 'sometimes', 'breakfast', 'yesterday', 'afternoon', 'meanwhile', 'therefore', 'otherwise', 'anywhere', 'dangerous', 'poisonous', 'mysterious', 'adventure',
        'signature', 'furniture', 'structure', 'departure', 'sculpture', 'procedure', 'disclosure', 'enclosure', 'exposure',
        'screwdriver',
        -- 10-letter words
        'everything', 'everywhere', 'nowhere', 'specifically', 'particularly', 'especially', 'unfortunately', 'immediately', 'separately', 'ultimately', 'potentially',
        'understand', 'sweetheart', 'cheesecake', 'earthquake', 'greenhouse', 'lighthouse', 'warehouse',
        'powerhouse', 'firehouse', 'roadhouse', 'gatehouse', 'treehouse', 'clubhouse', 'playhouse', 'schoolhouse', 'courthouse', 'farmhouse',
        'tremendous', 'stupendous', 'horrendous', 'continuous', 'victorious', 'glorious', 'notorious', 'cautious',
        'ambitious', 'nutritious', 'malicious', 'suspicious', 'delicious', 'precious', 'spacious', 'gracious', 'audacious',
        'generation', 'population', 'information', 'registration', 'imagination',
        'celebration', 'preparation', 'observation', 'reservation', 'conservation', 'conversation', 'demonstration', 'investigation', 'concentration', 'recommendation',
        'thoroughly', 'instantly', 'ultimately', 'eventually', 'basically', 'typically', 'generally', 'naturally', 'certainly', 'perfectly', 'obviously', 'seriously',
        'incredible', 'believable', 'achievable', 'dependable', 'acceptable', 'accessible', 'successful', 'respectful', 'thoughtful',
        'blackberry', 'cranberry', 'gooseberry', 'elderberry', 'raspberry', 'huckleberry',
        -- 11+ letter words
        'organization', 'administration', 'communication', 'transportation',
        -- Additional variety words
        'ocean', 'river', 'valley', 'canyon', 'tower', 'power', 'flour', 'devour', 'socks', 'shoes', 'boots', 'pants', 'dress'
    }
}
