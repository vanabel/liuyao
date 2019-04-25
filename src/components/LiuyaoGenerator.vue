<template>
  <div id="generator">
    <nav class="demo">
      <router-link to='/' class='brand'> {{ brand }} </router-link>
      <input id="bmenub" type="checkbox" class="show">
      <label for="bmenub" class="burger pseudo button">导航</label>

      <div class="menu">
        <router-link to='/yaogua'>摇卦</router-link>
        <router-link to='/jiegua'>解卦</router-link>
        <router-link to='/knowledge'>知识</router-link>
      </div>
    </nav>
  </div>
</template>

<script>
export default {
  name: 'LiuyaoGenerator',
  props: {
    brand: String
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
