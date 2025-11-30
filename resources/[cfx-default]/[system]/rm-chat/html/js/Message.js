Vue.component('message', {
    template: '#message_template',
    data(){
        return {};
    },
    computed: {
        processedTag(){
            // If tag is explicitly provided, use it
            if (this.tag && typeof this.tag === 'object' && this.tag.name) {
                return this.tag;
            }

            // Handle args as array
            let argsArray;
            if (Array.isArray(this.args)) {
                argsArray = this.args;
            } else if (typeof this.args === 'string') {
                argsArray = [this.args];
            } else {
                argsArray = [];
            }

            // If args is an array with more than 1 element, use first arg as tag
            if (argsArray.length > 1) {
                return {
                    name: argsArray[0],
                    background: this.getTagColorForName(argsArray[0])
                };
            }

            return null;
        },
        processedArgs(){
            // Handle args as string or array
            let argsArray;
            if (Array.isArray(this.args)) {
                argsArray = this.args;
            } else if (typeof this.args === 'string') {
                argsArray = [this.args];
            } else if (this.args === null || this.args === undefined) {
                argsArray = [];
            } else {
                argsArray = [String(this.args)];
            }

            // If we have multiple args and no explicit tag, skip first arg (it becomes the tag)
            if (argsArray.length > 1 && (!this.tag || !this.tag.name)) {
                return argsArray.slice(1);
            }

            return argsArray;
        },
        textEscaped(){
            const argsArray = this.processedArgs;

            // Get the template string
            let s = this.template ? this.template : this.templates[this.templateId];

            if (this.template){
                this.templateId = -1;
            }

            // If we used first arg as tag and only have 1 remaining arg, use defaultAlt template
            if (argsArray.length == 1 && this.hasTag && !this.tag){
                s = this.templates[CONFIG.defaultAltTemplateId];
            }
            // Handle backward compatibility for single arg
            else if (this.templateId == CONFIG.defaultTemplateId && argsArray.length == 1){
                s = this.templates[CONFIG.defaultAltTemplateId];
            }

            // Replace placeholders with escaped args
            s = s.replace(/{(\d+)}/g, (match, number) => {
                const argIndex = parseInt(number);
                const arg = argsArray[argIndex];
                if (arg !== undefined) {
                    return this.escape(String(arg));
                }
                if (argIndex == 0 && this.color) {
                    return match;
                }
                return match;
            });

            return this.colorize(s);
        },
        hasTag(){
            const tag = this.processedTag;
            if (!tag) return false;
            if (!tag.name) return false;
            return true;
        },
        tagStyle(){
            if (!this.hasTag || !this.processedTag) return '';
            const bgColor = this.processedTag.background || 'var(--mantine-color-blue)';
            return `background-color: ${bgColor};`;
        }
    },
    methods: {
        getTagColorForName(name){
            // Auto-assign colors based on tag name
            const colorMap = {
                'SYSTEM': 'var(--mantine-color-blue)',
                'WARNING': 'var(--mantine-color-orange)',
                'ERROR': 'var(--mantine-color-red)',
                'SUCCESS': 'var(--mantine-color-green)',
                'INFO': 'var(--mantine-color-cyan)',
                'ADMIN': 'var(--mantine-color-violet)',
            };

            const upperName = String(name).toUpperCase();
            return colorMap[upperName] || 'var(--mantine-color-blue)';
        },
        colorize(str){
            let s = "<span>" + (str.replace(/\^([0-9])/g, (str, color) => `</span><span class="color-${color}">`)) + "</span>";

            const styleDict = {
                '*': 'font-weight: bold;',
                '_': 'text-decoration: underline;',
                '~': 'text-decoration: line-through;',
                '=': 'text-decoration: underline line-through;',
                'r': 'text-decoration: none;font-weight: normal;'
            };

            const styleRegex = /\^(\_|\*|\=|\~|\/|r)(.*?)(?=$|\^r|<\/em>)/;
            while(s.match(styleRegex)){
                s = s.replace(styleRegex, (str, style, inner) => `<em style="${styleDict[style]}">${inner}</em>`)
            }
            return s.replace(/<span[^>]*><\/span[^>]*>/g, '');
        },
        escape(unsafe){
            return String(unsafe)
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#039;');
        }
    },
    props: {
        templates: {
            type: Object
        },
        args: {
            type: Array,
            default: () => []
        },
        template: {
            type: String,
            default: null
        },
        templateId: {
            type: String,
            default: CONFIG.defaultTemplateId
        },
        multiline: {
            type: Boolean,
            default: false
        },
        color: {
            type: Array,
            default: false
        },
        tag: {
            type: Object,
            default: () => ({})
        }
    }
});