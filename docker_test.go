package manual_connections_test

import (
	"context"
	"fmt"
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

	It("should not print the PIA_TOKEN", func(ctx context.Context) {
		cmd := exec.CommandContext(ctx, "docker", "run", "--rm",
			"--env", fmt.Sprintf("PIA_PASS=%s", piaPass),
			"--env", fmt.Sprintf("PIA_USER=%s", piaUser),
			image,
		)

		ses, err := gexec.Start(cmd, GinkgoWriter, GinkgoWriter)

		Expect(err).NotTo(HaveOccurred())
		Eventually(ses, "15s").Should(gexec.Exit(0))
		Expect(ses.Out).NotTo(gbytes.Say(`PIA_TOKEN=(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?`))
	})
})
