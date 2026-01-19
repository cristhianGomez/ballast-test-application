# ---

**GenAI Usage & Implementation Log**

This document outlines the interaction with GenAI (Claude 3.5 Sonnet) used to architect and optimize the SEO infrastructure of this project.

## **1\. Technical Prompting**

**Tool:** Claude 3.5 Sonnet

**Role Defined:** Senior Software Architect (Next.js & Web Performance Specialist)

### **The Prompt**

Review the current SEO implementation in our Next.js App Router frontend. Ensure the implementation aligns with **Next.js 15+ Metadata API** standards (avoiding deprecated head.js or manual \<head\> tags). Verify support for **Dynamic Metadata**, Open Graph (OG) tags, and **JSON-LD structured data**. Optimize for **Core Web Vitals** and semantic HTML structure. Suggest improvements for accessibility (A11y) that impact SEO rankings. Context: This is a containerized monorepo.

## ---

**2\. AI-Generated Implementation Plan**

The following plan was generated to address existing gaps in the SEO architecture:

### **Current State Assessment**

* **Existing:** Basic root metadata, next/image optimization, and Radix UI accessibility foundation.  
* **Gaps Identified:** Lack of dynamic metadata for Pokemon pages, missing sitemap.ts/robots.ts, and absent JSON-LD structured data.

### **Proposed Phases**

1. **Core Infrastructure:** Centralize site constants in src/lib/seo.ts and enhance the root layout.  
2. **Metadata API:** Implement generateMetadata() for dynamic routing in src/app/pokemon/\[id\]/page.tsx.  
3. **Structured Data:** Create specialized SEO components for CollectionPage and Article schemas.  
4. **Bot Indexing:** Programmatic generation of robots.txt and sitemap.xml using Next.js file-based metadata.

## ---

**3\. Manual Modifications & Architect's Review**

After receiving the AI suggestions, the following manual optimizations were performed to ensure compatibility with the containerized monorepo and WSL2 environment:

* **WSL2 Performance Fix:** While the AI suggested standard watchers, I manually moved the project to the native Linux filesystem (\~/) to resolve filesystem event latency issues that were breaking Hot Module Replacement (HMR).  
* **Environment Variable Security:** Refactored the SEO helpers to use NEXT\_PUBLIC\_SITE\_URL from .env.local, ensuring that metadata links are correctly generated for both development (localhost) and production environments.  
* **Dynamic Route Optimization:** Added generateStaticParams() to the Pokemon detail pages. This ensures that the most popular assets are pre-rendered at build time, significantly improving **Largest Contentful Paint (LCP)**.  
* **Metadata Validation:** Manually verified the HMR WebSocket connection inside the Docker container to ensure metadata updates reflect instantly during development.

## ---

**4\. Verification Checklist**

To confirm the success of the implementation, the following verification steps are utilized:

1. **Rich Results Test:** Validating JSON-LD via Google's Structured Data tool.  
2. **Lighthouse Audit:** Confirming 90+ scores in SEO and Accessibility.  
3. **Metadata Debugging:** Checking \<head\> output for Open Graph and Twitter Card compliance.

### ---
