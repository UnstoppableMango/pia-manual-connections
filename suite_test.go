package manual_connections_test

import (
	"context"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"testing"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
	"github.com/onsi/gomega/gexec"
	"github.com/unmango/go/vcs/git"
)

const (
	image = "unstoppablemango/pia-manual-connections:e2e"
)

var (
	gitRoot    string
	dockerfile string
	piaPass    string
	piaUser    string
)

func TestManualConnections(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "ManualConnections Suite")
}

var _ = BeforeSuite(func(ctx context.Context) {
	var err error

	By("Locating the git root directory")
	gitRoot, err = git.Root(ctx)
	Expect(err).NotTo(HaveOccurred())

	dockerfile = filepath.Join(gitRoot, "Dockerfile")
	cmd := exec.CommandContext(ctx, "docker", "build",
		"-f", dockerfile, "-t", image, gitRoot,
	)

	By("Building the image")
	ses, err := gexec.Start(cmd, GinkgoWriter, GinkgoWriter)
	Expect(err).NotTo(HaveOccurred())
	Eventually(ses, "30s").Should(gexec.Exit(0))

	By("Retrieving the PIA credentials")
	if piaPass = os.Getenv("PIA_PASS"); piaPass == "" {
		fmt.Fprint(GinkgoWriter, "PIA_PASS not set")
	}
	if piaUser = os.Getenv("PIA_USER"); piaUser == "" {
		fmt.Fprint(GinkgoWriter, "PIA_USER not set")
	}
})
