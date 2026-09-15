<script setup lang="ts">
import { ref, reactive } from 'vue'
const msg = 'test val'
const msgId = 'msg-id'
const isActive = true
const hasError = false
const objectAttrs = {
  id: msgId,
  class: 'title',
  style: 'color: green; background-color: black;',
}
const html = '<h1>raw html</h1>'
const arr = [1, 2, 3, 4, 5]
const click = (event: MouseEvent) => {
  console.log(event)
  console.log('clicked')
}
</script>

<template>
  <main>
    <h1 v-bind="objectAttrs">{{ msg }}</h1>
    <h1 :class="{ active: isActive, error: hasError }">dynamic class</h1>
    <div v-html="html"></div>
    <button @click="click">Click Me</button>
    <p v-if="arr.length === 5">arr length: 5</p>
    <p v-else-if="arr.length === 3">arr length: 3</p>
    <p v-else>arr length: not 3,5</p>
    <p v-for="(item, index) in arr" :key="index">{{ item }}</p>
    <div v-once>
      <h1>Comment</h1>
      <p>{{ msg }}</p>
    </div>
    <p v-pre>
      {{ message }}
    </p>
    <p v-pre v-cloak>
      {{ message }}
    </p>
    <p v-cloak>
      {{ message }}
    </p>
  </main>
</template>
