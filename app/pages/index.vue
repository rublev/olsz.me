<script setup>
import GLYPHS from '@/assets/glyphs.json'
</script>

<template>
  <div
    class="
      mx-auto max-w-2xl font-bold
      md:px-4
    "
  >
    <article class="pt-8">
      <h1 class="mb-2 font-['PP_Mondwest'] text-4xl font-bold">
        Hey, I'm Marcel {{ GLYPHS.katakana.shi }}<span class="text-green-400">
          {{ GLYPHS.mondwest.alembic }}
        </span>
        <!-- </span><br>
        &#x26C5; &#x265F;
        &#x25CA;
        &#x25A0;
        &#x25A1;
        &#x25A6;
        &#x25A7;
        &#x25A8;
        &#x25A8;
        &#x25A9;

        &#x2600;
        &#x2601;
        &#x2602;
        &#x2603;
        &#x2614;
        &#x2628;

        &#x263C;
        &#x265C;
        &#x2697;
        &#x26C8;
        &#x25A9;
        &#x266C;
        &#x266B;
        &#x266A;
        &#x2669;
        &#x2728;

        №1
        &#xFB00;
        &#xFB01;
        &#xFB02;
        &#xFB03;
        &#x30FE;五 -->
      </h1>
      <h3 class="mb-6 font-['PP_Mondwest'] text-xl font-normal">
        №1 Full stack developer & designer -----
      </h3>
      <p class="mb-3 font-['PP_NeueBit'] text-xl">
        Things I've worked on:
      </p>
      <ul
        class="
          mb-6 list-disc space-y-2 pl-6 font-['PP_NeueBit'] text-4xl leading-6
          tracking-wide
        "
      >
        <li class="before:mr-1 before:-ml-5 before:content-['-']">
          AI QA automation tool @ <a
            href="https://browsertest.ai"
            class="relative text-red-400 transition-all duration-200"
            title="Browsertest"
            style="--shadow-color: red"
          >
            Browsertest
          </a>
        </li>
        <li class="before:mr-1 before:-ml-5 before:content-['-']">
          Conversational AI agent @ <a
            href="https://valery.ca"
            class="relative transition-all duration-200"
            title="Valery"
            style="--shadow-color: #D2691E; --face-color: orange"
          >
            Valery
          </a>
        </li>
        <li class="before:mr-1 before:-ml-5 before:content-['-']">
          Full-stack development @ <a
            href="https://stratosphere.digital"
            class="relative transition-all duration-200"
            title="Stratosphere"
            style="--shadow-color: #D2691E; --face-color: orange"
          >
            Stratosphere
          </a>
        </li>
        <li class="before:mr-1 before:-ml-5 before:content-['-']">
          Financial planning software @ <a
            href="https://compoundplanning.com/"
            class="relative transition-all duration-200"
            title="Compound Planning"
            style="--shadow-color: #757500; --face-color: #ffff00"
          >
            Compound Planning
          </a>
        </li>
        <li class="before:mr-1 before:-ml-5 before:content-['-']">
          Enterprise solutions @ <a
            href="https://web.archive.org/web/20221024023347/https://supaglobal.com/"
            class="relative transition-all duration-200"
            title="Supa Global"
            style="--shadow-color: #0022b4; --face-color: #2e54f9"
          >
            Supa Global
          </a>
        </li>
        <li class="before:mr-1 before:-ml-5 before:content-['-']">
          Blockchain infrastructure @ <a
            href="https://consensys.io"
            class="relative transition-all duration-200"
            title="ConsenSys"
          >
            ConsenSys
          </a>
        </li>
        <li class="before:mr-1 before:-ml-5 before:content-['-']">
          Co-founded & sold <a
            href="https://dailycodingproblem.com"
            class="relative transition-all duration-200"
            title="Daily Coding Problem"
            style="--shadow-color: #2ab380; --face-color: black"
          >
            Daily Coding Problem</a> <a
            href="https://techcrunch.com/2018/03/13/y-combinator-alum-daily-coding-problem-acquired-by-alpine-data-labs/"
            class="
              text-xs text-green-500 underline transition-all duration-200
              hover:rounded hover:bg-green-500 hover:text-white
              hover:no-underline
              dark:text-green-500 dark:hover:text-white
            "
          >
            (acq)</a> <span
            class="
              text-xs text-gray-600
              dark:text-gray-600
            "
          >/</span> <a
            href="https://www.producthunt.com/products/daily-coding-problem/launches/daily-coding-problem"
            target="_blank"
            class="
              text-xs text-purple-500 underline transition-all duration-200
              hover:rounded hover:bg-purple-500 hover:text-white
              hover:no-underline
              dark:text-purple-500 dark:hover:text-white
            "
          >
            #2 ph
          </a>
        </li>
        <li class="before:mr-1 before:-ml-5 before:content-['-']">
          Cryptocurrency wallet @ <a
            href="https://apps.apple.com/us/app/brd-bitcoin-wallet/id885251393"
            class="relative transition-all duration-200"
            title="Breadwallet"
            style="--shadow-color: DeepPink; --face-color: black"
          >
            Breadwallet</a> <a
            href="https://www.coindesk.com/business/2021/11/24/coinbase-acquires-crypto-wallet-firm-brd-for-undisclosed-amount"
            class="
              text-xs text-green-500 underline transition-all duration-200
              hover:rounded hover:bg-green-500 hover:text-white
              hover:no-underline
              dark:text-green-500 dark:hover:text-white
            "
          >
            (acq, Coinbase)
          </a>
        </li>
        <li class="before:mr-1 before:-ml-5 before:content-['-']">
          Banking systems @ <a
            href="https://rbcroyalbank.com"
            class="relative transition-all duration-200"
            title="RBC Royal Bank"
            style="--shadow-color: #FFD200; --face-color: #005DAA"
          >
            RBC Royal Bank
          </a>
        </li>
      </ul>

      <!-- <p
        class="
          mt-6 mb-1 font-['PP_NeueBit'] text-lg text-gray-600
          dark:text-gray-400
        "
      >
        Other clients:
      </p>
      <p
        class="
          mb-3 font-['PP_NeueBit'] text-base text-gray-600
          dark:text-gray-400
        "
      >
        Coinbase, Driveway, Secureframe, SignupMedia, Ways2Well, Vitalsphere, Steeprock OLA, Knit People, Keyhole, Simpletax, Interad, Redstamp
      </p>

      <hr
        class="
          my-12 border-gray-300
          dark:border-gray-700
        "
      > -->

      <!-- <h3 class="mb-4 font-['PP_Mondwest'] text-2xl font-bold">
        Reach out
      </h3>
      <ul class="mb-4 list-none space-y-1 pl-0 font-['PP_NeueBit'] text-base">
        <li>
          GitHub <a
            href="https://github.com/olstenlarck"
          >
            <span class="relative text-black">
              @olstenlarck
            </span>
          </a>
        </li>
        <li>
          LinkedIn <a
            href="https://www.linkedin.com/in/marcelolszewski/"
          >
            <span class="relative text-black">
              marcelolszewski
            </span>
          </a>
        </li>
        <li>
          10x Management <a
            href="https://app.10xmanagement.com/clients/marcel-olszewski-16302/profile"
          >
            <span class="relative text-black">
              Profile
            </span>
          </a>
        </li>
        <li>
          Email <a
            href="mailto:marcel@olsz.me"
          >
            <span class="relative text-black">
              marcel@olsz.me
            </span>
          </a>
        </li>
      </ul> -->

      <!-- <small class="mt-32 block font-['PP_NeueBit'] text-xs">
        2025 © Marcel Olszewski.
      </small> -->
    </article>
    <!-- <div class="box theme-a">
      Theme A (initial)
    </div>
    <div class="box theme-a adaptive">
      Theme A (changed if dark preferred)
    </div>
    <br>

    <div class="box theme-b">
      Theme B (initial)
    </div>
    <div class="box theme-b adaptive">
      Theme B (changed if light preferred)
    </div> -->
  </div>
</template>

<!-- <style scoped>
.theme-a {
  background: #ddccaa;
  color: #773311;
}
@media (prefers-color-scheme: dark) {
  .theme-a.adaptive {
    background: #775533;
    color: #ddccbb;
    outline: 5px dashed black;
  }
}

.theme-b {
  background: #444477;
  color: #bbbbdd;
}
@media (prefers-color-scheme: light) {
  .theme-b.adaptive {
    background: #bbccdd;
    color: #333344;
    outline: 5px dotted black;
  }
}
</style> -->
