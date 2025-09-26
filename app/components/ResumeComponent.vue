<script>
// Resume component displaying Marcel Olszewski's professional experience
// Uses Tailwind CSS for styling with responsive design
export default {
  name: 'ResumeComponent',
}
</script>

<template>
  <div class="mx-auto max-w-4xl bg-background p-8">
    <!-- Header Section -->
    <div class="mb-8">
      <h1 class="mb-2 text-4xl font-bold text-primary">
        Marcel Olszewski
      </h1>
      <p class="mb-4 text-muted-foreground">
        Largely self-educated web developer with backgrounds in software
        development and engineering. Expert generalist known for turning
        ambiguous ideas into clean, performant UIs.
      </p>
      <div
        class="
          grid grid-cols-1 gap-4 text-sm text-muted-foreground
          md:grid-cols-2
        "
      >
        <div>
          <p>
            Phone: +1 (647) 834-8234
          </p>
          <p>
            Email: marcel.olszewski@gmail.com
          </p>
        </div>
        <div>
          <p>
            LinkedIn:
            <a
              href="https://linkedin.com/in/molsz"
              class="
                text-primary
                hover:underline
              "
            >
              linkedin.com/in/molsz
            </a>
          </p>
          <p>
            GitHub:
            <a
              href="https://github.com/rublev"
              class="
                text-primary
                hover:underline
              "
            >
              github.com/rublev
            </a>
          </p>
          <p>
            Website:
            <a
              href="https://olsz.me"
              class="
                text-primary
                hover:underline
              "
            >
              olsz.me
            </a>
          </p>
        </div>
      </div>
    </div>

    <!-- Professional Experience Section -->
    <div class="mb-10">
      <h2 class="mb-6 text-xl font-bold tracking-wide text-primary uppercase">
        Professional Experience
      </h2>

      <!-- CTO & Founder, browsertest.ai -->
      <div class="mb-8">
        <div class="mb-2 flex items-start justify-between">
          <div>
            <h3 class="text-lg font-bold text-foreground">
              CTO & Founder, browsertest.ai
            </h3>
            <p class="text-muted-foreground">
              Artificial Intelligence & Automation
            </p>
          </div>
          <p class="text-sm text-muted-foreground">
            Sep 2024 — Present
          </p>
        </div>
        <ul class="space-y-2 text-sm text-foreground">
          <li>
            • Developed an agentic QA automation tool catering to non-technical
            and time-constrained developers for effortless creation of
            self-healing test suites.
          </li>
          <li>
            • Implemented project management strategies across the company for
            efficiency and alignment.
          </li>
          <li>
            • Optimized DevOps pipelines to cut expenses and improve workflow
            efficiency.
          </li>
          <li>
            • Led and managed development tasks for an international team.
          </li>
        </ul>
      </div>

      <!-- Senior Software Engineer, Valery.ca -->
      <div class="mb-8">
        <div class="mb-2 flex items-start justify-between">
          <div>
            <h3 class="text-lg font-bold text-foreground">
              Senior Software Engineer, Valery.ca
            </h3>
            <p class="text-muted-foreground">
              AI-Powered Real Estate Platform
            </p>
          </div>
          <p class="text-sm text-muted-foreground">
            May 2024 — May 2025
          </p>
        </div>
        <ul class="space-y-2 text-sm text-foreground">
          <li>
            • Developed and deployed a real estate AI chatbot using Next.js,
            PostgreSQL, Pinecone, and Airtable with design crafted in Figma.
            Built conversational AI using RAG system with real-time market data
            integration for the Canadian market.
          </li>
          <li>
            • Specialized in healthcare projects by integrating EHR and
            platforms.
          </li>
        </ul>
      </div>

      <!-- Senior Software Developer, Stratosphere.digital -->
      <div class="mb-8">
        <div class="mb-2 flex items-start justify-between">
          <div>
            <h3 class="text-lg font-bold text-foreground">
              Senior Software Developer, Stratosphere.digital
            </h3>
            <p class="text-muted-foreground">
              Fintech, Healthcare, B2C
            </p>
          </div>
          <p class="text-sm text-muted-foreground">
            Dec 2021 — Jan 2024
          </p>
        </div>
        <ul class="space-y-2 text-sm text-foreground">
          <li>
            • Designed and implemented various browser and mobile applications
            for leading healthcare organizations. Developed a Web3 NFT Social
            Network using Dfinity's Internet Computer Protocol, creating smart
            contracts in Motoko and building a custom NFT marketplace with
            React. Collaborated with diverse clients including driveway.app,
            steeprockinc.com, vitalsphere.digital, and signupmedia.com.
          </li>
        </ul>
      </div>

      <!-- Senior Full Stack Developer, Compound Planning -->
      <div class="mb-8">
        <div class="mb-2 flex items-start justify-between">
          <div>
            <h3 class="text-lg font-bold text-foreground">
              Senior Full Stack Developer, Compound Planning
            </h3>
            <p class="text-muted-foreground">
              Fintech
            </p>
          </div>
          <p class="text-sm text-muted-foreground">
            Sep 2019 — Dec 2019
          </p>
        </div>
        <ul class="space-y-2 text-sm text-foreground">
          <li>
            • Developed user onboarding system using React and TypeScript.
            Created initial designs and prototypes in Sketch & InvisionApp,
            which were then implemented as functional components. Streamlined
            stock options process for employees.
          </li>
        </ul>
      </div>

      <!-- Co-Founder, Supaglobal.com -->
      <div class="mb-8">
        <div class="mb-2 flex items-start justify-between">
          <div>
            <h3 class="text-lg font-bold text-foreground">
              Co-Founder, Supaglobal.com
            </h3>
            <p class="text-muted-foreground">
              Fintech
            </p>
          </div>
          <p class="text-sm text-muted-foreground">
            Jun 2018 — Sep 2019
          </p>
        </div>
        <ul class="space-y-2 text-sm text-foreground">
          <li>
            • Created personalized real estate investment options for various
            investor profiles. Developed the AI stack using Java and implemented
            the frontend with Vue.js. Led technical decision-making processes,
            developed demos for stakeholders, and ensured data contract
            security.
          </li>
        </ul>
      </div>

      <!-- Senior Full Stack Developer, ConsenSys -->
      <div class="mb-8">
        <div class="mb-2 flex items-start justify-between">
          <div>
            <h3 class="text-lg font-bold text-foreground">
              Senior Full Stack Developer, ConsenSys
            </h3>
            <p class="text-muted-foreground">
              Cryptocurrency
            </p>
          </div>
          <p class="text-sm text-muted-foreground">
            Apr 2018 — Dec 2018
          </p>
        </div>
        <ul class="space-y-2 text-sm text-foreground">
          <li>
            • Worked primarily on the frontend and design of the Project Numia
            stablecoin exchange which is now PayTrie. Built out RESTful API
            using Node.js with fastify.js & knex.js. API testing with supertest.
            Built mobile responsive frontend with various API integrations such
            as Plaid for payments.
          </li>
        </ul>
      </div>

      <!-- Co-Founder, Daily Coding Problem -->
      <div class="mb-8">
        <div class="mb-2 flex items-start justify-between">
          <div>
            <h3 class="text-lg font-bold text-foreground">
              Co-Founder, Daily Coding Problem (Acquired)
            </h3>
            <p class="text-muted-foreground">
              Education
            </p>
          </div>
          <p class="text-sm text-muted-foreground">
            Sep 2017 — Mar 2018
          </p>
        </div>
        <ul class="space-y-2 text-sm text-foreground">
          <li>
            • Designed and implemented a personalized computer science question
            and solution mailing list. Led development of a free daily coding
            problem subscription service with premium options. Achieved rapid
            growth from $0 to $8k Monthly Recurring Revenue (MRR) in just two
            months. Reached #2 on Product Hunt.
          </li>
        </ul>
      </div>

      <!-- Senior Full Stack Developer, Breadwallet -->
      <div class="mb-8">
        <div class="mb-2 flex items-start justify-between">
          <div>
            <h3 class="text-lg font-bold text-foreground">
              Senior Full Stack Developer, Breadwallet (Acquired)
            </h3>
            <p class="text-muted-foreground">
              Cryptocurrency
            </p>
          </div>
          <p class="text-sm text-muted-foreground">
            Aug 2016 — Jun 2017
          </p>
        </div>
        <ul class="space-y-2 text-sm text-foreground">
          <li>
            • Developed a secure iOS bitcoin wallet app with integrated exchange
            functionality. Built a bitcoin exchange using internal proxy API to
            securely communicate with Kraken's API in Golang. Integrated
            exchange directly into wallet app to streamline buying and selling
            bitcoin for users. Acquired by Coinbase.
          </li>
        </ul>
      </div>

      <!-- Technical Systems Analyst, RBC -->
      <div class="mb-8">
        <div class="mb-2 flex items-start justify-between">
          <div>
            <h3 class="text-lg font-bold text-foreground">
              Technical Systems Analyst, RBC
            </h3>
            <p class="text-muted-foreground">
              Fintech
            </p>
          </div>
          <p class="text-sm text-muted-foreground">
            Jan 2013 — Apr 2014
          </p>
        </div>
        <ul class="space-y-2 text-sm text-foreground">
          <li>
            • Designed and implemented user interface for RBC Express Mobile
            Business Banking app using jQuery Mobile and Phonegap on various
            devices including Android 4.0+, all iPhone and iPad models, and
            Blackberry devices. Developed internal tools like CSS Optimizer and
            HTML5 Code Integrator to enhance code integration.
          </li>
        </ul>
      </div>
    </div>

    <!-- OSS Projects Section -->
    <div class="mb-10">
      <h2 class="mb-6 text-xl font-bold tracking-wide text-primary uppercase">
        OSS Projects
      </h2>

      <!-- OpenXR Recenter Override -->
      <div class="mb-6">
        <div class="mb-2 flex items-start justify-between">
          <h3 class="text-lg font-bold text-foreground">
            OpenXR Recenter Override
          </h3>
          <p class="text-sm text-muted-foreground">
            <a
              href="https://github.com/rublev/openxr-recenter"
              class="
                text-primary
                hover:underline
              "
            >
              github.com/rublev/openxr-recenter
            </a>
          </p>
        </div>
        <p class="mb-2 text-sm text-foreground">
          Developed an OpenXR API layer for VR position override and cockpit
          alignment. Intercepts
          <code class="rounded bg-muted px-1 text-foreground">
            xrLocateViews()
          </code>
          and
          <code class="rounded bg-muted px-1 text-foreground">
            xrLocateSpace()
          </code>
          calls to apply saved positional adjustments across VR sessions.
          Features quaternion-based pose transformations, multi-space coordinate
          system handling, DirectX overlay rendering for visual markers, and
          comprehensive input handling. Compatible with OpenXR runtimes
          including SteamVR, Oculus, and Windows Mixed Reality.
        </p>
      </div>
    </div>

    <!-- Notable Projects Section -->
    <div class="mb-10">
      <h2 class="mb-6 text-xl font-bold tracking-wide text-primary uppercase">
        Notable Projects
      </h2>

      <!-- Browsertest.ai -->
      <div class="mb-6">
        <div class="mb-2 flex items-start justify-between">
          <h3 class="text-lg font-bold text-foreground">
            Browsertest.ai
          </h3>
        </div>
        <p class="mb-2 text-sm text-foreground">
          Built an agentic QA automation tool for non-developers to streamline
          E2E testing that turns natural language into replayable test steps
          against a live browser session. The system supports both manual and
          AI-driven test flows and is designed to make E2E testing of modern web
          apps fast, visual, and intuitive. Features include embedded real-time
          60fps interactive browser, component definition for reuse, test
          scheduling, and real-time script generation for Playwright, Puppeteer,
          Nightwatch, and Cypress.
        </p>
      </div>

      <!-- Daily Coding Problem -->
      <div class="mb-6">
        <div class="mb-2 flex items-start justify-between">
          <h3 class="text-lg font-bold text-foreground">
            Daily Coding Problem (Acquired)
          </h3>
        </div>
        <p class="mb-2 text-sm text-foreground">
          Built and launched dailycodingproblem.com, a subscription-based
          platform that delivers one high-quality computer science interview
          question per day to users' inboxes covering key topics like algorithms
          and data structures. Achieved rapid growth from $0 to $8k Monthly
          Recurring Revenue (MRR) in just two months by providing an alternative
          approach to persistent LeetCode-style challenges. Reached #2 on
          Product Hunt.
        </p>
      </div>
    </div>

    <!-- Clients Section -->
    <div class="mb-10">
      <h2 class="mb-6 text-xl font-bold tracking-wide text-primary uppercase">
        Clients
      </h2>

      <div class="space-y-2 text-sm text-foreground">
        <p>
          <strong>
            Through Stratosphere.digital:
          </strong>
          Driveway.app, Secureframe, SignupMedia, Ways2Well, Vitalsphere,
          Steeprock OLA
        </p>
        <p>
          <strong>
            Select Clients:
          </strong>
          Valery.ca, ConsenSys, Knit People, BRD/Breadwallet (Acquired),
          Keyhole, NorthernBlock, VeriTransfer, SimpleTax (Acquired), Interad,
          Redstamp, RBC Royal Bank
        </p>
      </div>
    </div>

    <!-- Programming Experience Section -->
    <div class="mb-10">
      <h2 class="mb-6 text-xl font-bold tracking-wide text-primary uppercase">
        Programming Experience
      </h2>

      <div class="space-y-4 text-sm text-foreground">
        <div>
          <p>
            <strong>
              Expert:
            </strong>
            AWS, JavaScript, TypeScript, Node.js, Vue.js, React, Svelte, HTMX,
            WebGL, Docker, API Design, PostgreSQL, Natural Language Processing,
            LLM, AI Agent, UI/UX Design, Full Stack Development
          </p>
        </div>
        <div>
          <p>
            <strong>
              Proficient:
            </strong>
            C++17, OpenXR API, DirectX 11, Quaternion Mathematics, Windows API,
            Python, React Native, Ruby on Rails, A/B Testing, Firebase, Google
            Cloud, Serverless, Webpack, Adobe Suite
          </p>
        </div>
      </div>
    </div>

    <!-- Languages Section -->
    <div class="mb-10">
      <h2 class="mb-6 text-xl font-bold tracking-wide text-primary uppercase">
        Languages
      </h2>

      <div class="space-y-2 text-sm text-foreground">
        <p>
          <strong>
            Fluent:
          </strong>
          English, Polish
        </p>
        <p>
          <strong>
            Learning:
          </strong>
          German, Ukrainian
        </p>
      </div>
    </div>

    <!-- Education Section -->
    <div class="mb-8">
      <h2 class="mb-6 text-xl font-bold tracking-wide text-primary uppercase">
        Education
      </h2>

      <div class="space-y-4">
        <div class="flex items-start justify-between">
          <div>
            <h3 class="text-lg font-bold text-foreground">
              Seneca Polytechnic, Toronto, ON
            </h3>
            <p class="text-sm text-foreground">
              Bachelor of Technology, Software Development
            </p>
          </div>
          <p class="text-sm text-muted-foreground">
            Jan 2011 — Jul 2013
          </p>
        </div>

        <div class="flex items-start justify-between">
          <div>
            <h3 class="text-lg font-bold text-foreground">
              York University, Toronto, ON
            </h3>
            <p class="text-sm text-foreground">
              Bachelor of Engineering, Software Engineering
            </p>
          </div>
          <p class="text-sm text-muted-foreground">
            Jan 2010 — Jul 2011
          </p>
        </div>
      </div>
    </div>
  </div>
</template>
