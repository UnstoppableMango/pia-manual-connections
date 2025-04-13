package manual_connections_test

import (
	"context"
	"os/exec"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
	"github.com/onsi/gomega/gbytes"
	"github.com/onsi/gomega/gexec"
)

var _ = Describe("Docker Manual Connections", func() {
	It("should fail when password is not provided", func(ctx context.Context) {
		cmd := exec.CommandContext(ctx, "docker", "run", "--rm", image)

		ses, err := gexec.Start(cmd, GinkgoWriter, GinkgoWriter)

		Expect(err).NotTo(HaveOccurred())
		Eventually(ses, "10s").Should(gexec.Exit(1))
		Expect(ses.Out).To(gbytes.Say("Please set the PIA_PASS environment variable"))
	})
})
