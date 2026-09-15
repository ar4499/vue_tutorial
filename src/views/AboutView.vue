<script setup lang="ts">
import {
  ref,
  reactive,
  computed,
  watch,
  watchEffect,
  onWatcherCleanup,
  watchSyncEffect,
  watchPostEffect,
} from 'vue'
const message = ref('')
const count = 0
const countRef = ref(0)
const nested = ref({
  obj: { count: 0 },
  arr: [1, 2],
})
const isActive = ref(true)
const isMultiActive = ref([])
const picked = ref('')
const selected = ref('')
const multiSelected = ref([])
const toggleActive = () => {
  isActive.value = !isActive.value
}
//console.log(countRef)
//console.log(countRef.value)
const countReactive = reactive({ count: 0 })
const mutateNest = () => {
  nested.value.obj.count++
  nested.value.arr.push(nested.value.arr[nested.value.arr.length - 1] + 1)
}
const author = reactive({
  name: 'John Doe',
  books: ['Vue 2 - Advanced Guide', 'Vue 3 - Basic Guide', 'Vue 4 - The Mystery'],
})

// 算出 ref
const publishedBooksMessage = computed((previous) => {
  // console.log(previous)
  return author.books.filter((i) => i.includes('Advanced')).length === 1 ? 'yes' : 'No'
})
//console.log(publishedBooksMessage) // Object { fn: publishedBooksMessage(), setter: undefined, _value: undefined, dep: {…}, __v_isRef: true, deps: undefined, depsTail: undefined, flags: 16, globalVersion: 0, next: undefined, … }
//console.log(publishedBooksMessage.value) // yes

const user = reactive({ firstName: 'John', lastName: 'Doe' })
const fullName = computed({
  get() {
    return `${user.firstName} ${user.lastName}`
  },
  set(newValue) {
    ;[user.firstName, user.lastName] = newValue.split(' ')
  },
})
fullName.value = 'John Smith'
//console.log(user.firstName)
//console.log(user.lastName)
const postId = ref(1)
const post = ref(null)
const postStatus = ref('')
const loading = ref(false)
//watch(
//  postId,
//  async (currentPostId, previousPostId) => {
//    console.log(previousPostId, currentPostId)
//    const controller = new AbortController()
//    if (currentPostId > 0 && currentPostId <= 100) {
//      loading.value = true
//      postStatus.value = 'Loading...'
//      try {
//        const res = await fetch(`https://jsonplaceholder.typicode.com/posts/${currentPostId}`, {
//          signal: controller.signal,
//        })
//        post.value = await res.json()
//      } catch (error) {
//        postStatus.value = "Error! Couldn't fetch jsonplaceholder " + error
//        console.log(error)
//      } finally {
//        loading.value = false
//      }
//    }
//    onWatcherCleanup(() => {
//      controller.abort()
//    })
//  },
//
//  //{ immediate: true, once: true },
//)

watchEffect(async () => {
  if (postId.value > 0 && postId.value <= 100) {
    loading.value = true
    postStatus.value = 'Loading...'
    const controller = new AbortController()
    try {
      const res = await fetch(`https://jsonplaceholder.typicode.com/posts/${postId.value}`, {
        signal: controller.signal,
      })
      post.value = await res.json()
    } catch (error) {
      postStatus.value = "Error! Couldn't fetch jsonplaceholder " + error
      console.log(error)
    } finally {
      loading.value = false
    }
    onWatcherCleanup(() => {
      controller.abort()
    })
  }
})
const items = ref([0])
const itemNum = ref(0)

watchSyncEffect(async () => {
  console.log('called')
  for (let i = 0; i < itemNum.value; i++) {
    items.value.push(i + 1)
  }
})
</script>
<template>
  <div class="about">
    <button @click="count++">
      {{ count }}
    </button>
    <button @click="countRef++">
      {{ countRef }}
    </button>
    <button @click="mutateNest">
      {{ `${nested.obj.count}: ${nested.arr}` }}
    </button>
    <button @click="countReactive.count++">
      {{ countReactive.count }}
    </button>
    <p>{{ publishedBooksMessage }}</p>
    <p>{{ fullName }}</p>
    <p v-show="isActive">Active!</p>
    <button @click="toggleActive">ClickMe</button>
    <input type="checkbox" id="checkbox" v-model="isActive" />
    <input v-model="message" placeholder="type here" />
    <textarea v-model="message" placeholder="type here" />
    <p>typed: {{ message }}</p>
    <div>
      <input type="checkbox" id="checkbox" v-model="isActive" />
      <label for="checkbox">{{ isActive }}</label>
    </div>
    <div>
      <input type="checkbox" id="checkbox" value="1" v-model="isMultiActive" />
      <input type="checkbox" id="checkbox" value="2" v-model="isMultiActive" />
      <input type="checkbox" id="checkbox" value="3" v-model="isMultiActive" />
      <label for="checkbox">{{ isMultiActive }}</label>
    </div>
    <div>
      <div>Picked: {{ picked }}</div>

      <input type="radio" id="one" value="One" v-model="picked" />
      <label for="one">One</label>

      <input type="radio" id="two" value="Two" v-model="picked" />
      <label for="two">Two</label>
    </div>
    <div>
      <div>Selected: {{ selected }}</div>

      <select v-model="selected">
        <option disabled value="">Please select one</option>
        <option>A</option>
        <option>B</option>
        <option>C</option>
      </select>
    </div>
    <div>
      <div>Selected: {{ multiSelected }}</div>

      <select v-model="multiSelected" multiple>
        <option disabled value="">Please select one</option>
        <option>A</option>
        <option>B</option>
        <option>C</option>
      </select>
    </div>
    <div>
      <input type="text" v-model.number.trim="postId" placeholder="Enter PostId 1~100" />
      <p v-show="loading">{{ postStatus }}</p>
      <p v-show="!loading">{{ post }}</p>
    </div>
    <div>
      <input type="text" v-model.number.trim="itemNum" placeholder="Enter ItemNum" />
      <p>{{ items }}</p>
    </div>
  </div>
</template>
