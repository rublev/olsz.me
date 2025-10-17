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
      <div class="mx-auto max-w-4xl p-8">
        <div class="border-2 border-gray-300 p-6">
          <div class="flex gap-4">
            <!-- SIDEBAR -->
            <div class="w-24 flex-shrink-0 space-y-4">
              <a
                href="https://app.10xmanagement.com/clients/marcel-olszewski-16302/profile"
                target="_blank"
              >
                <Icon name="svg:10x-pixelated" class="h-auto w-8" color="white" />
              </a>
              <a href="mailto:hi@olsz.me">
                <Icon name="svg:email" class="h-auto w-8" color="white" />
              </a>
              <a href="https://github.com/rublev" target="_blank">
                <Icon name="svg:github" class="h-auto w-8" color="white" />
              </a>
              <a
                href="https://www.linkedin.com/in/marcelolszewski/"
                target="_blank"
              >
                <Icon name="svg:linkedin" class="h-auto w-8" color="white" />
              </a>
            </div>
            <!-- CONTENT -->
            <div class="flex-1 space-y-4">
              <!-- top header section -->
              <div class="flex flex-col gap-2.5">
                <h1 id="fag" class="font-mondwest text-5xl font-bold">
                  Hey, I'm Marcel {{ GLYPHS.katakana.shi }}
                </h1>
                <p class="font-mondwest text-2xl font-normal">
                  Frontend & design oriented full-stack developer
                </p>
              </div>
              <!-- JOBS -->
              <ul
                class="
                  mb-6 list-disc space-y-2 pl-6 font-['PP_NeueBit'] text-4xl
                  leading-6 tracking-wide
                "
              >
                <li class="before:mr-1 before:-ml-5 before:content-['-']">
                  AI QA automation tool @
                  <a
                    href="https://browsertest.ai"
                    class="relative text-red-400 transition-all duration-200"
                    title="Browsertest"
                    style="--shadow-color: red"
                  >
                    Browsertest
                  </a>
                </li>
                <li class="before:mr-1 before:-ml-5 before:content-['-']">
                  Conversational AI agent @
                  <a
                    href="https://valery.ca"
                    class="relative transition-all duration-200"
                    title="Valery"
                    style="--shadow-color: #d2691e; --face-color: orange"
                  >
                    Valery
                  </a>
                </li>
                <li class="before:mr-1 before:-ml-5 before:content-['-']">
                  Full-stack development @
                  <a
                    href="https://stratosphere.digital"
                    class="relative transition-all duration-200"
                    title="Stratosphere"
                    style="--shadow-color: #d2691e; --face-color: orange"
                  >
                    Stratosphere
                  </a>
                </li>
                <li class="before:mr-1 before:-ml-5 before:content-['-']">
                  Financial planning software @
                  <a
                    href="https://compoundplanning.com/"
                    class="relative transition-all duration-200"
                    title="Compound Planning"
                    style="--shadow-color: #757500; --face-color: #ffff00"
                  >
                    Compound Planning
                  </a>
                </li>
                <li class="before:mr-1 before:-ml-5 before:content-['-']">
                  Enterprise solutions @
                  <a
                    href="https://web.archive.org/web/20221024023347/https://supaglobal.com/"
                    class="relative transition-all duration-200"
                    title="Supa Global"
                    style="--shadow-color: #0022b4; --face-color: #2e54f9"
                  >
                    Supa Global
                  </a>
                </li>
                <li class="before:mr-1 before:-ml-5 before:content-['-']">
                  Blockchain infrastructure @
                  <a
                    href="https://consensys.io"
                    class="relative transition-all duration-200"
                    title="ConsenSys"
                  >
                    ConsenSys
                  </a>
                </li>
                <li class="before:mr-1 before:-ml-5 before:content-['-']">
                  Co-founded & sold
                  <a
                    href="https://dailycodingproblem.com"
                    class="relative transition-all duration-200"
                    title="Daily Coding Problem"
                    style="--shadow-color: #2ab380; --face-color: black"
                  >
                    Daily Coding Problem</a>
                  <a
                    href="https://techcrunch.com/2018/03/13/y-combinator-alum-daily-coding-problem-acquired-by-alpine-data-labs/"
                    class="
                      text-xs text-green-500 underline transition-all
                      duration-200
                      hover:rounded hover:bg-green-500 hover:text-white
                      hover:no-underline
                      dark:text-green-500 dark:hover:text-white
                    "
                  >
                    (acq)</a>
                  <span
                    class="
                      text-xs text-gray-600
                      dark:text-gray-600
                    "
                  >
                    /
                  </span>
                  <a
                    href="https://www.producthunt.com/products/daily-coding-problem/launches/daily-coding-problem"
                    target="_blank"
                    class="
                      text-xs text-purple-500 underline transition-all
                      duration-200
                      hover:rounded hover:bg-purple-500 hover:text-white
                      hover:no-underline
                      dark:text-purple-500 dark:hover:text-white
                    "
                  >
                    #2 ph
                  </a>
                </li>
                <li class="before:mr-1 before:-ml-5 before:content-['-']">
                  Cryptocurrency wallet @
                  <a
                    href="https://apps.apple.com/us/app/brd-bitcoin-wallet/id885251393"
                    class="relative transition-all duration-200"
                    title="Breadwallet"
                    style="--shadow-color: DeepPink; --face-color: black"
                  >
                    Breadwallet</a>
                  <a
                    href="https://www.coindesk.com/business/2021/11/24/coinbase-acquires-crypto-wallet-firm-brd-for-undisclosed-amount"
                    class="
                      text-xs text-green-500 underline transition-all
                      duration-200
                      hover:rounded hover:bg-green-500 hover:text-white
                      hover:no-underline
                      dark:text-green-500 dark:hover:text-white
                    "
                  >
                    (acq, Coinbase)
                  </a>
                </li>
                <li class="before:mr-1 before:-ml-5 before:content-['-']">
                  Banking systems @
                  <a
                    href="https://rbcroyalbank.com"
                    class="relative transition-all duration-200"
                    title="RBC Royal Bank"
                    style="--shadow-color: #ffd200; --face-color: #005daa"
                  >
                    RBC Royal Bank
                  </a>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>

      <p
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
        Coinbase, Driveway, Secureframe, SignupMedia, Ways2Well, Vitalsphere,
        Steeprock OLA, Knit People, Keyhole, Simpletax, Interad, Redstamp
      </p>

      <hr
        class="
          my-12 border-gray-300
          dark:border-gray-700
        "
      >

      <h3 class="mb-4 font-['PP_Mondwest'] text-2xl font-bold">
        Reach out
      </h3>
      <ul class="mb-4 list-none space-y-1 pl-0 font-['PP_NeueBit'] text-base">
        <li>
          GitHub
          <a href="https://github.com/rublev" />
        </li>
        <li>
          LinkedIn
          <a href="https://www.linkedin.com/in/marcelolszewski/">
            <span class="relative text-black">
              marcelolszewski
            </span>
          </a>
        </li>
        <li>
          10x Management
          <a
            href="https://app.10xmanagement.com/clients/marcel-olszewski-16302/profile"
          >
            <span class="relative text-black">
              Profile
            </span>
          </a>
        </li>
      </ul>
    </article>
  </div>
</template>
