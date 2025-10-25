<template>
  <div class="container h-dvh w-screen">
    <!-- eslint-disable-next-line better-tailwindcss/no-unregistered-classes -->
    <div class="broider selected">
      <div class="h-full w-full">
        awd
      </div>
      <!-- <img
        id="scale"
        alt="scale"
        src="/assets/animations/night.gif"
        style="
          image-rendering: pixelated;
          width: 100%;
          height: 100%;
          display: block;
        "
      > -->
    </div>
  </div>
</template>

<style scoped lang="scss">
.container {
  border: 2px solid red;
  background: lime;
  position: relative;
}

.broider {
  --size: 28;
  filter: none !important;
  /* transform: scale(3); */
  // position: relative;
}

.broider::after {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  border-image: url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAFQAAABUCAYAAAAcaxDBAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAFYSURBVHgB7dw9DoJAFADhhVhpa6MH9FAeUBtrS7EFJMiysxt+5utUYjF5eVkStKpO5yYIUwehDAozKOww8N4jKMa1/cIJhRkUZlDYYcI1z6C2y9iHTijMoDCDwqbs0L69nVOvMRc7oTCDwgwKm7NDO6pqW+fUphk/Z/7jhMIMCjMoLHmHDljbTk3amX1OKMygMIPCcuzQjs9nWff+dR13bx79/UEog8IMCsu+Q3+8X/dQ0vF8CwU5oTCDwgwKMyjMoDCDwgwKMyjMoDCDwgwKMyjMoDCDwgwKMyjMoDCDwgwKMyjMoDCDwgwKMyjMoDCDwgwKK/9sU+FnjUpzQmEGhRkUln2H5n6mfWmcUJhBYQaF5dih6G8n18YJhRkUZlBY8g5N/Y+OrXFCYQaFGRQ2Z4fu6t48lhMKMyjMoLApO9RzZgQnFGZQmEFhQzvUc2YCJxRmUJhBYV89hxICTkccdwAAAABJRU5ErkJggg==")
    var(--size) / calc(var(--size) * 1px) round;
  border-width: calc(var(--size) * 1px);
  border-style: solid;
  pointer-events: none;
  image-rendering: pixelated;
  // transform: scale(1.2);
  // transform-origin: 0cap;
}

#target {
  overflow: hidden;
  justify-self: end;
  width: 80%;
  max-width: 450px;
  position: relative;
  /* height: 100%; */
}

#target:after {
  content: attr(data-after);
  /* position: absolute; */
  right: 4px;
  bottom: 4px;
}

#scale {
  justify-self: end;
  align-self: flex-end;
  /* height: 96px; */
  image-rendering: pixelated;
}

@media only screen and (max-width: 700px) {
  .desktop {
    display: none !important;
  }
}
</style>
