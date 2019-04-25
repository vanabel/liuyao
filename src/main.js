import Vue from 'vue'
import VueRouter from 'vue-router'
import App from './App.vue'
import Yaogua from './components/Yaogua.vue'
import Jiegua from './components/Jiegua.vue'
//import Knowledge from './components/Knowledge.vue'
import ZhouYi from './components/ZhouYi.vue'
Vue.config.productionTip = false

Vue.use(VueRouter)

const router = new VueRouter({
  mode: 'history',
  base: __dirname,
  routes:[
    { path: '/' , name: 'home', component: Yaogua },
    { path: '/yaogua', component: Yaogua },
    { path: '/jiegua', component: Jiegua },
    { path: '/knowledge', component: ZhouYi, props: (route) => ({ q: route.query.q }) }
  ]
})

new Vue({
  router,
  render: h => h(App),
}).$mount('#app')
