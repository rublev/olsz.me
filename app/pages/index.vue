<script setup>
import { ref } from 'vue'

const isAnyHovered = ref(false)

function handleCardHover() {
  isAnyHovered.value = true
}

function handleCardUnhover() {
  isAnyHovered.value = false
}

const projects = [
  {
    href: 'https://browsertest.ai',
    title: 'Browsertest',
    initials: 'BT',
    iconBgClass: 'bg-blue-600',
    role: 'CTO & Founder',
    period: 'Sep 2024 - Present',
    brandColor: '#003cff',
    isCurrentWork: true,
  },
  {
    href: 'https://browsertest.ai',
    title: 'Browsertest',
    initials: 'BT',
    iconBgClass: 'bg-blue-600',
    role: 'CTO & Founder',
    period: 'Sep 2024 - Present',
    brandColor: '#003cff',
    isCurrentWork: true,
  },
  {
    href: 'https://valery.ca',
    title: 'Valery',
    initials: 'V',
    iconBgClass: 'bg-green-600',
    role: 'Senior Software Engineer',
    period: 'May 2024 - May 2025',
    brandColor: '#b5feee',
  },
  {
    href: 'https://stratosphere.digital',
    title: 'Stratosphere',
    initials: 'SD',
    iconBgClass: 'bg-purple-600',
    role: 'Senior Software Developer',
    period: 'Dec 2021 - Jan 2024',
    brandColor: '#ff5c00',
  },
  {
    href: 'https://compoundplanning.com/',
    title: 'Compound Planning',
    initials: 'CP',
    iconBgClass: 'bg-purple-600',
    role: 'Senior Software Developer',
    period: 'Sep 2019 - Dec 2019',
    brandColor: '#ffe9bf',
  },
  {
    href: 'https://web.archive.org/web/20221024023347/https://supaglobal.com/',
    title: 'Supa Global',
    initials: 'CP',
    iconBgClass: 'bg-purple-600',
    role: 'Senior Software Developer',
    period: 'Jun 2018 - Sep 2019',
    brandColor: '#2e54f9',
  },
  {
    href: 'https://consensys.io',
    title: 'ConsenSys',
    initials: 'C',
    iconBgClass: 'bg-orange-600',
    role: 'Senior Full Stack Developer',
    period: 'Apr 2018 - Dec 2018',
    brandColor: '#cbfa15',
  },
  {
    href: 'https://dailycodingproblem.com',
    title: 'Daily Coding Problem',
    initials: 'DC',
    iconBgClass: 'bg-red-600',
    role: 'Co-Founder (Acquired)',
    period: 'Sep 2017 - Mar 2018',
    brandColor: '#2ab380',
  },
  {
    href: 'https://apps.apple.com/us/app/brd-bitcoin-wallet/id885251393',
    title: 'Breadwallet',
    initials: 'BR',
    iconBgClass: 'bg-yellow-600',
    role: 'Senior Full Stack Developer',
    period: 'Aug 2016 - Jun 2017',
    brandColor: '#fb7e61',
  },
  {
    href: 'https://rbcroyalbank.com',
    title: 'RBC Royal Bank',
    initials: 'RBC',
    iconBgClass: 'bg-yellow-600',
    role: 'Technical Systems Analyst',
    period: 'Aug 2016 - Jun 2017',
    brandColor: '#005DAA',
  },
]

const currentProjects = projects.filter(project => project.isCurrentWork)
const workHistory = projects.filter(project => !project.isCurrentWork)
</script>

<template>
  <main
    class="
      mx-auto flex h-full max-w-[680px] flex-col gap-16 py-16 pt-[20vh] pb-8
    "
  >
    <section>
      <h1
        class="mb-6 text-[1.4rem] leading-8 font-extrabold text-white"
        style="text-wrap: balance"
      >
        Marcel Olszewski
      </h1>
      <p class="mt-4 text-[1.275rem] leading-[1.875rem] text-gray-300">
        I'm a full-stack engineer and entrepreneur building tools that solve
        real problems. This is my personal space on the web, where I share
        projects, thoughts, and discoveries.
      </p>
    </section>

    <!-- <section>
      <h2 class="mb-6 text-sm font-medium text-gray-400">
        Current Projects
      </h2>
      <div class="flex flex-wrap gap-2 rounded-lg">
        <ProjectCard
          v-for="project in currentProjects"
          :key="project.href"
          :href="project.href"
          :title="project.title"
          :initials="project.initials"
          :icon-bg-class="project.iconBgClass"
          :role="project.role"
          :period="project.period"
          :brand-color="project.brandColor"
          :is-active="!isAnyHovered"
          @hover="handleCardHover"
          @unhover="handleCardUnhover"
        />
      </div>
    </section>

    <section>
      <h2 class="mb-6 text-sm font-medium text-gray-400">
        Work & Projects
      </h2>
      <div class="flex flex-wrap gap-2 rounded-lg">
        <ProjectCard
          v-for="project in workHistory"
          :key="project.href"
          :href="project.href"
          :title="project.title"
          :initials="project.initials"
          :icon-bg-class="project.iconBgClass"
          :role="project.role"
          :period="project.period"
          :brand-color="project.brandColor"
          :is-active="false"
          @hover="handleCardHover"
          @unhover="handleCardUnhover"
        />
      </div>
    </section> -->
  </main>
</template>
