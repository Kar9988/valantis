<script setup>
import {onMounted, ref} from "vue";
import {md5} from "js-md5";
import axios from "axios";
import moment from "moment";

axios.defaults.headers['X-Auth'] = md5(`Valantis_${moment().format('yyyyMMDD')}`)
const apiUrl = 'http://api.valantis.store:40000/'
const items = ref([])
const page = ref(1)
const isLoading = ref(false)
onMounted(() => {
  getItemsIds()
})

const getItems = (ids = []) => {
  axios.post(apiUrl, {
    "action": "get_items",
    "params": {
      "ids": ids
    }
  }).then(({data}) => {
    const keys = ['id'];
    items.value = data.result.filter((value, index, self) =>
        self.findIndex(v => keys.every(k => v[k] === value[k])) === index
    ) ?? []
    isLoading.value = true
  }).catch((e) => {
    console.log(e);
    getItemsIds(true)
  })
}
const getItemsIds = (repeat = false) => {
  isLoading.value = true
  return axios.post(apiUrl, {
    "action": "get_ids",
    "params": {
      "offset": page.value * 10,
      "limit": 10
    }
  }).then(({data}) => {
    getItems(data.result ?? [])
  }).catch((e) => {
    if (!repeat) {
      getItemsIds(true)
      console.log(e);
    }
  })
}
const prevPage = () => {
  page.value--
  getItemsIds(false)
}
const nextPage = () => {
  page.value++
  getItemsIds(false)
}
</script>

<template>
  <div>
    <div class="mt-3 w-6/12 mx-auto">
      <div class="rounded bg-white shadow-md" style="width: 1063px;">
        <div class="overflow-x-auto">

          <table class="table-fixed w-auto min-w-full">
            <thead class="bg-gray-200 border-gray-300 border-t border-b">
            <tr>
              <th class="font-medium text-sm p-2 text-right" style="width: 100px;">ID</th>
              <th class="font-medium text-sm p-2 text-left" style="width: 500px;">Brand</th>
              <th class="font-medium text-sm p-2 text-left" style="width: 200px;">Price</th>
              <th class="font-medium text-sm p-2 text-left" style="width: 200px;">Product</th>
            </tr>

            </thead>
            <tbody>
            <tr v-if="isLoading">
              <td colspan="4" class="text-center"> <!-- Use colspan to span across all columns -->
                <div class="w-12 h-12 mt-5 mx-auto rounded-full animate-spin border-2 border-solid border-blue-500 border-t-transparent"></div>
              </td>
            </tr>
            <tr v-else class="border-gray-300 border-b hover:bg-gray-100" v-for="(item, index) in items" :key="index">
              <td class="text-sm font-medium text-right"><a href="#" class="inline-block p-2 w-full truncate">{{ item.id }}</a></td>
              <td class="text-sm" style="max-width: 200px;">{{ item.brand }}</td>
              <td class="text-sm">{{ item.price }}</td>
              <td class="text-sm">{{ item.product }}</td>
            </tr>
            </tbody>
          </table>

        </div>
        <div class="py-4 px-5 flex justify-between items-center">
          <div>
            <button :disabled="isLoading || page < 2" @click="prevPage()"
                    class="px-8 py-3 disabled:bg-gray-300 text-white bg-sky-500 hover:bg-sky-700 rounded focus:outline-none">
              Previous
            </button>
            <button :disabled="isLoading" @click="nextPage()"
                    class="px-8 py-3 disabled:bg-gray-300 ml-3 text-white bg-sky-500 hover:bg-sky-700 rounded focus:outline-none">
              Next
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style>

</style>
