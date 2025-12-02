<template>
  <v-app style="background: transparent!important;">
    <v-fade-transition>
      <div class="dialog-bg" v-if="show">
        <v-card class="card">
          <v-card-title class="title">
            <div>
              <span class="font-weight-bold mr-2">
                {{ data.firstname }} 
              </span>
              <span class="font-weight-light">
                {{ data.lastname }}
              </span>
            </div>
            <div style="flex-grow: 1;">

            </div>
            <div class="note" v-if="data.rep">
              {{ data.rep }} Rep
            </div>
            <div class="note" v-if="data.type">
              {{ data.type }}
            </div>
          </v-card-title>
          <div class="text-dialog">
            <div class="text">
              {{ data.text }}
            </div>
            <div class="buttons">
              <div class="button" v-for="(item, index) in data.buttons" @keyup.index="click(item)" @click="click(item)">
                <div class="number">
                  <p>
                    {{ index+1 }}
                  </p>
                </div>
                {{ item.text }}
              </div>
            </div>
          </div>
        </v-card>
      </div>
    </v-fade-transition>
  </v-app>
</template>

<script>
export default {
  name: 'App',
  components: {
  },
  data: () => ({
    show: false,
    data: {
      firstname: 'John',
      lastname: 'Doe',
      text: 'Lorem ipsum dolor sit amet',
      type: '',
      rep: '',
      buttons: [
        { text: 'Lorem ipsum dolor sit amet' }
      ]
    }
  }),

  methods: {
    click(data){
      // In dev mode, just log the click and close the dialog
      if (import.meta.env.DEV) {
        console.log('Dialog button clicked:', data);
        this.show = false;
        // Reset after a short delay to see the close animation
        setTimeout(() => {
          this.show = true;
        }, 300);
        return;
      }
      
      post('click', data, (resp) => {
        if (resp == 'close') {
          this.show = false;
          this.data = null;
        }
      })
    },
  },

  mounted() {
    // Show dialog in dev mode for editing
    if (import.meta.env.DEV) {
      this.show = true;
    }

    this.escapeListener = window.addEventListener("keyup", (event) => {
      if (!this.show) {
        return
      }
      if (event.keyCode || 49 && event.keyCode || 51 && event.keyCode || 52 && event.keyCode || 53) { 
        if ( this.data.buttons[event.keyCode - 49] ) {
          this.click(this.data.buttons[event.keyCode - 49])
        }
      }
    });
    this.messageListener = window.addEventListener("message", (event) => {
      const item = event.data || event.detail; //'detail' is for debugging via browsers
      if (item.type == 'New') {
        this.data = item.data
        this.show = true
      } else if (item.type == 'Continue') {
        this.data.text = item.data.text
        this.data.buttons = item.data.buttons
      } else if (item.type == 'Set') {
        this.data = item.data
        this.show = true
      } else if (item.type == 'Close') {
        this.show = false;
        this.data = null;
      }
    });
  },
}

const resource = 'dialog';

const post = (event, data, cb) => {
  if (event) {
    fetch(`https://${resource}/${event}`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: JSON.stringify(data || {}),
    })
      .then((resp) => resp.json())
      .then((resp) => {
        if (cb) {
          cb(resp);
        }
      });
  }
};


</script>

<style>

html {
  overflow: hidden!important;
  background: transparent !important;
}

body {
  background: transparent !important;
  background-color: transparent !important;
}

:root {
  color-scheme: dark !important;
  --item-color: #c2f4f91e;
  --bg-color: #121a1ce3;
  --main-color: #C2F4F9;
  --border-color: #c2f4f967;
  --key-bg: #384f524f;
}

#app {
  background: transparent!important;
  background-color: transparent!important;
}

/* Ensure Vuetify v-app is transparent */
.v-application {
  background: transparent !important;
  background-color: transparent !important;
}

/* width */
::-webkit-scrollbar {
  width: 0px;
  height: 0px;
}

/* Track */
::-webkit-scrollbar-track {
  background: #f1f1f1;
}

/* Handle */
::-webkit-scrollbar-thumb {
  background: #888;
}

/* Handle on hover */
::-webkit-scrollbar-thumb:hover {
  background: #555;
}

</style>
