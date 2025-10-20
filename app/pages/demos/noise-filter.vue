<template>
  <div
    class="
      grid place-items-center border-[10px] border-red-500 bg-black text-white
    "
  >
    <svg
      xmlns="http://www.w3.org/2000/svg"
      class="absolute -m-px h-px w-px"
    >
      <defs>
        <filter id="noise">
          <feOffset
            in="SourceGraphic"
            dx="-8"
            dy="-8"
            result="offset"
          />
          <feGaussianBlur
            in="offset"
            stdDeviation="64"
            result="blur"
          />
          <feTurbulence
            result="waves"
            type="turbulence"
            baseFrequency="0.735 0.771"
            numOctaves="1"
            seed="256"
          />
          <feDisplacementMap
            in="blur"
            in2="waves"
            scale="320"
            xChannelSelector="R"
            yChannelSelector="B"
            result="ripples"
          />
          <feComposite
            in="waves"
            in2="ripples"
            operator="arithmetic"
            k1="1"
            k2="0"
            k3="1"
            k4="0"
          />
        </filter>
      </defs>
    </svg>

    <div
      class="
        relative h-[300px] w-[300px] overflow-hidden bg-black blur-[0.33px]
      "
      style="
        clip-path: polygon(0 0, 50% 0, 100% 50%, 100% 100%, 50% 100%, 0 50%);
      "
    >
      <div
        class="absolute top-0 left-0 h-full w-full rounded-full bg-white"
        style="filter: url(&quot;#noise&quot;)"
      />
      <div
        class="absolute top-0 left-0 h-full w-full"
        style="
          background: radial-gradient(
            circle at 100% 100%,
            white 10%,
            33%,
            transparent 66.7%
          );
        "
      />
    </div>
  </div>
</template>
