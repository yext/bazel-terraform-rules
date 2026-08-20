package main

import (
	"encoding/json"
	"fmt"
	"html/template"
	"log"
	"net/http"
	"os"
	"path"
	"sort"
	"strings"
)

type Asset struct {
	Name               string `json:"name"`
	BrowserDownloadURL string `json:"browser_download_url"`
	Digest             string `json:"digest"`
}

type Release struct {
	TagName string  `json:"tag_name"`
	Assets  []Asset `json:"assets"`
}

type Build struct {
	OS   string
	Arch string
	URL  string
	SHA  string
}

type Version struct {
	Version string
	Builds  []Build
}

func main() {
	releases := getAllOpenTofuReleases()

	t, err := template.New("opentofu_versions.bzl").Parse(tmpl)
	if err != nil {
		panic(err)
	}

	f, err := os.Create(path.Join(os.Getenv("BUILD_WORKSPACE_DIRECTORY"), "toolchains", "opentofu", "versions.bzl"))
	if err != nil {
		panic(err)
	}
	defer f.Close()

	err = t.Execute(f, releases)
	if err != nil {
		panic(err)
	}
}

func getAllOpenTofuReleases() []Version {
	var (
		versions []Version
		page     int
	)

	for {
		resp, err := http.Get(fmt.Sprintf("https://api.github.com/repos/opentofu/opentofu/releases?per_page=20&page=%d", page+1))
		if err != nil {
			log.Fatalln(err)
		}
		defer resp.Body.Close()
		if resp.StatusCode != http.StatusOK {
			log.Fatalf("unexpected status fetching releases: %s", resp.Status)
		}

		var releases []Release
		if err := json.NewDecoder(resp.Body).Decode(&releases); err != nil {
			log.Fatalln(err)
		}

		for _, release := range releases {
			buildsByPlatform := map[string]Build{}

			for _, item := range release.Assets {
				platform, ok := platformFromAsset(item.Name)
				if !ok {
					continue
				}

				buildsByPlatform[platform] = Build{
					OS:   strings.Split(platform, "_")[0],
					Arch: strings.Split(platform, "_")[1],
					URL:  item.BrowserDownloadURL,
					SHA:  strings.TrimPrefix(item.Digest, "sha256:"),
				}
			}

			if len(buildsByPlatform) == 0 {
				continue
			}

			platforms := make([]string, 0, len(buildsByPlatform))
			for platform := range buildsByPlatform {
				platforms = append(platforms, platform)
			}
			sort.Strings(platforms)

			builds := make([]Build, 0, len(platforms))
			for _, platform := range platforms {
				builds = append(builds, buildsByPlatform[platform])
			}

			versions = append(versions, Version{
				Version: strings.TrimPrefix(release.TagName, "v"),
				Builds:  builds,
			})
		}

		if len(releases) < 20 {
			break
		}

		page += 1
	}

	return versions
}

func fetchSHA(url string) string {
	resp, err := http.Get(url)
	if err != nil {
		log.Fatalln(err)
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		log.Fatalf("unexpected status fetching sha: %s", resp.Status)
	}

	var sha string
	if _, err := fmt.Fscan(resp.Body, &sha); err != nil {
		log.Fatalln(err)
	}
	return sha
}

func platformFromAsset(name string) (string, bool) {
	if !strings.HasSuffix(name, ".zip") || !strings.HasPrefix(name, "tofu_") {
		return "", false
	}

	trimmed := strings.TrimSuffix(name, ".zip")
	parts := strings.Split(trimmed, "_")
	if len(parts) < 4 {
		return "", false
	}

	osName := parts[len(parts)-2]
	arch := parts[len(parts)-1]
	return osName + "_" + arch, true
}

const tmpl = `
## Generated file - do not edit
# Below is a full set of OpenTofu release information, including URLs and checksums.
#
# To update this file, run:
# bazel run //tools/getopentofureleases

VERSIONS = {
{{- range . }}
  "{{.Version}}": {
    {{- range .Builds }}
	"{{.OS}}_{{.Arch}}": {
	  "url": "{{.URL}}",
	  "sha": "{{.SHA}}",
	},
    {{- end }}
  },
{{- end }}
}
`
