<template>
  <div id="app">
    <LiuyaoGenerator brand="六爻预测"/>
    <router-view />
  </div>
</template>

<script>
import LiuyaoGenerator from './components/LiuyaoGenerator.vue'
export default {
  name: 'app',
  components: {
      LiuyaoGenerator
  }
}
</script>

<style>
@import "../node_modules/picnic/picnic.min.css";
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: left;
  color: #2c3e50;
  padding: 60px 5px;
}
</style>
