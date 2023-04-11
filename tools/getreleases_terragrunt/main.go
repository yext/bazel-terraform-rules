package main

import (
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"path"
	"regexp"
	"strings"
	"text/template"
)

func main() {
	releases := getAllTerragruntReleases()
	populated := populateSHASums(releases)

	t, err := template.New("terragrunt_versions.bzl").Parse(tmpl)
	if err != nil {
		panic(err)
	}

	f, err := os.Create(path.Join(os.Getenv("BUILD_WORKSPACE_DIRECTORY"), "toolchains", "terragrunt", "versions.bzl"))
	if err != nil {
		panic(err)
	}
	defer f.Close()

	err = t.Execute(f, populated)
	if err != nil {
		panic(err)
	}
}

type Asset struct {
	Name string `json:"name"`
	URL  string `json:"browser_download_url"`

	SHA       string
	ShortName string
}

type Release struct {
	Tag    string  `json:"tag_name"`
	Assets []Asset `json:"assets"`
}

var (
	whitespace = regexp.MustCompile(`[^\s]+`)
)

func populateSHASums(releases []Release) []Release {
	var out []Release
	for _, release := range releases {
		var (
			outAssets     = []Asset{}
			sha256sumsURL = ""
		)
		for _, asset := range release.Assets {
			if asset.Name == "SHA256SUMS" {
				sha256sumsURL = asset.URL
				continue
			}
		}

		if sha256sumsURL == "" {
			log.Fatalln("no SHA256SUMS file found for release", release.Tag)
		}

		fileToSha, err := loadSHASums(sha256sumsURL)
		if err != nil {
			log.Fatalln(err)
		}
		for _, asset := range release.Assets {
			var exists bool
			asset.SHA, exists = fileToSha[asset.Name]
			if exists {
				asset.ShortName = strings.TrimPrefix(asset.Name, "terragrunt_")
				outAssets = append(outAssets, asset)
			}
		}
		release.Assets = outAssets
		out = append(out, release)
	}
	return out
}

func loadSHASums(url string) (map[string]string, error) {
	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	// TODO: Verify signature of SHA file

	var fileToSha = make(map[string]string)
	for _, line := range strings.Split(string(body), "\n") {
		segments := whitespace.FindAllString(line, -1)
		if len(segments) == 2 {
			fileToSha[segments[1]] = segments[0]
		}
	}
	return fileToSha, nil
}

func getAllTerragruntReleases() []Release {
	var (
		out []Release
	)
	resp, err := http.Get("https://api.github.com/repos/gruntwork-io/terragrunt/releases")
	if err != nil {
		log.Fatalln(err)
	}

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatalln(err)
	}

	releases := []Release{}
	err = json.Unmarshal(body, &releases)
	if err != nil {
		log.Fatalln(err)
	}
	out = append(out, releases...)

	return out
}

const tmpl = `
## Generated file - do not edit
# Below is a full set of Terragrunt release information, including URLs and checksums.
#
# To update this file, run:
# bazel run //tools/getreleases_terragrunt

VERSIONS = {
{{- range . }}
  "{{.Tag}}": {
    {{- range .Assets }}
	"{{.ShortName}}": {
	  "url": "{{.URL}}",
	  "sha": "{{.SHA}}",
	},
    {{- end }}
  },
{{- end }}
}
`
