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
	image     = "unstoppablemango/pia-manual-connections:e2e"
	proxyAddr = "127.0.0.1:443"
	proxyIp   = "127.0.0.1"
	piaToken  = "test-token-please-ignore"
	piaUrl    = "www.privateinternetaccess.com"
)

var (
	gitRoot    string
	dockerfile string
	piaPass    string
	piaUser    string
	proxySes   *gexec.Session
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

	By("Starting the PIA proxy")
	cmd = exec.CommandContext(ctx, "go", "tool",
		"proxy", "--bind-addr", proxyAddr,
	)
	cmd.Env = append(cmd.Env,
		fmt.Sprintf("PIA_PROXY_TOKEN=%s", piaToken),
	)
	ses, err = gexec.Start(cmd, GinkgoWriter, GinkgoWriter)
	Expect(err).NotTo(HaveOccurred())
})
