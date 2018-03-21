<template>
  <div class="datetime" :datetime="formatted_datetime" :title="timezone" :data-timezone="timezone">{{formatted_datetime}}</div>
</template>

<script>
    export default {
        name: "datetime",
        props: ['utc_datetime'],
        data() {
            return {
                format: 'MMMM Do YYYY, h:mm:ss a',
            };
        },
        computed: {
            formatted_datetime() {
                return moment.utc(this.utc_datetime).local().format(this.format);
            },
            timezone() {
                return this.$parent.timezone;
            }
        }
    }
</script>

<style scoped>

</style>
