//======================================================================
//
// npts_interfaces.v
// -----------------
// This module contains the external interfaces used in the
// ntps FPGA design.
//
//
// Author: Joachim Strombergson
//
// Copyright (c) 2020, The Swedish Post and Telecom Authority (PTS)
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
//
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in
//    the documentation and/or other materials provided with the
//    distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
// FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
// COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
// LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
// ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//
//======================================================================

`default_nettype none

module ntps_interfaces(
                       input wire            reset,

                       // PCI-AXI interface and bridge.
                       input wire            pcie_perst,
                       input wire            pci_clk,
                       input wire [7:0]      pci_exp_rxn,
                       input wire [7:0]      pci_exp_rxp,
                       output wire [7:0]     pci_exp_txn,
                       output wire [7:0]     pci_exp_txp,

                       output wire           axi_aclk,
                       output wire           axi_aresetn,
                       output wire           user_link_up,

                       output wire [383 : 0] m_axi_awaddr,
                       output wire [35 : 0]  m_axi_awprot,
                       output wire [11 : 0]  m_axi_awvalid,
                       input  wire [11 : 0]  m_axi_awready,
                       output wire [383 : 0] m_axi_wdata,
                       output wire [47 : 0]  m_axi_wstrb,
                       output wire [11 : 0]  m_axi_wvalid,
                       input  wire [11 : 0]  m_axi_wready,
                       input  wire [23 : 0]  m_axi_bresp,
                       input  wire [11 : 0]  m_axi_bvalid,
                       output wire [11 : 0]  m_axi_bready,
                       output wire [383 : 0] m_axi_araddr,
                       output wire [35 : 0]  m_axi_arprot,
                       output wire [11 : 0]  m_axi_arvalid,
                       input  wire [11 : 0]  m_axi_arready,
                       input  wire [383 : 0] m_axi_rdata,
                       input  wire [23 : 0]  m_axi_rresp,
                       input  wire [11 : 0]  m_axi_rvalid,
                       output wire [11 : 0]  m_axi_rready,

                       // NTP clocks.
                       input wire            PPS_INA_N,
                       input wire            PPS_INA_P,
                       output wire           PPS_OUTA,
                       input wire            TEN_MHZ_INA_N,
                       input wire            TEN_MHZ_INA_P,
                       output wire           TEN_MHZ_OUTA,
                       output wire [63 : 0]  NTP_TIMEA,
                       output wire           NTP_TIME_UPDA,
                       output wire           NTP_LED1A,
                       output wire           NTP_LED2A,
                       output wire           SYNC_OKA,
                       output wire           PLL_LOCKEDA,

                       input wire            PPS_INB_N,
                       input wire            PPS_INB_P,
                       output wire           PPS_OUTB,
                       input wire            TEN_MHZ_INB_N,
                       input wire            TEN_MHZ_INB_P,
                       output wire           TEN_MHZ_OUTB,
                       output wire [63 : 0]  NTP_TIMEB,
                       output wire           NTP_TIME_UPDB,
                       output wire           NTP_LED1B,
                       output wire           NTP_LED2B,
                       output wire           SYNC_OKB,
                       output wire           PLL_LOCKEDB
                      );


  //----------------------------------------------------------------
  // Local parameters.
  //----------------------------------------------------------------
  localparam AXI_NTPA_INDEX = 0;
  localparam AXI_NTPB_INDEX = 1;


  //----------------------------------------------------------------
  // Wires.
  //----------------------------------------------------------------
  // PCI-AXI
  wire             axi_aclk;
  wire             axi_aresetn;
  wire             user_link_up;
  wire [384-1:0]   m_axi_awaddr;
  wire [36-1:0]    m_axi_awprot;
  wire [12-1:0]    m_axi_awvalid;
  wire [12-1:0]    m_axi_awready;
  wire [384-1:0]   m_axi_wdata;
  wire [384/8-1:0] m_axi_wstrb;
  wire [12-1:0]    m_axi_wvalid;
  wire [12-1:0]    m_axi_wready;
  wire [24-1:0]    m_axi_bresp;
  wire [12-1:0]    m_axi_bvalid;
  wire [12-1:0]    m_axi_bready;
  wire [384-1:0]   m_axi_araddr;
  wire [36-1:0]    m_axi_arprot;
  wire [12-1:0]    m_axi_arvalid;
  wire [12-1:0]    m_axi_arready;
  wire [384-1:0]   m_axi_rdata;
  wire [24-1:0]    m_axi_rresp;
  wire [12-1:0]    m_axi_rvalid;
  wire [12-1:0]    m_axi_rready;

  wire             pcie_clk;


  //----------------------------------------------------------------
  // Assignments for ports.
  //----------------------------------------------------------------


  //----------------------------------------------------------------
  // PCI-AXI instantiation.
  //----------------------------------------------------------------
  pcie_axi pcie_axi_0 (
    .reset         (reset),
    .pcie_perst    (pcie_perst),
    .pcie_clk      (pcie_clk),
    .pci_exp_rxn   (pci_exp_rxn),
    .pci_exp_rxp   (pci_exp_rxp),
    .pci_exp_txn   (pci_exp_txn),
    .pci_exp_txp   (pci_exp_txp),
    .axi_aresetn   (axi_aresetn),
    .axi_aclk      (axi_aclk),
    .m_axi_awaddr  (m_axi_awaddr),
    .m_axi_awprot  (m_axi_awprot),
    .m_axi_awvalid (m_axi_awvalid),
    .m_axi_awready (m_axi_awready),
    .m_axi_wdata   (m_axi_wdata),
    .m_axi_wstrb   (m_axi_wstrb),
    .m_axi_wvalid  (m_axi_wvalid),
    .m_axi_wready  (m_axi_wready),
    .m_axi_bresp   (m_axi_bresp),
    .m_axi_bvalid  (m_axi_bvalid),
    .m_axi_bready  (m_axi_bready),
    .m_axi_araddr  (m_axi_araddr),
    .m_axi_arprot  (m_axi_arprot),
    .m_axi_arvalid (m_axi_arvalid),
    .m_axi_arready (m_axi_arready),
    .m_axi_rdata   (m_axi_rdata),
    .m_axi_rresp   (m_axi_rresp),
    .m_axi_rvalid  (m_axi_rvalid),
    .m_axi_rready  (m_axi_rready),
    .user_link_up  (user_link_up)
   );


  //----------------------------------------------------------------
  // NTP clocks
  //----------------------------------------------------------------
  ntp_clock_top ntp_clock_topA (
    .reset        (reset),
    .axi_aclk     (axi_aclk),
    .axi_aresetn  (axi_aresetn),
    .axi_araddr   (m_axi_araddr [(AXI_NTPA_INDEX * 32) +: 5]),
    .axi_arprot   (m_axi_arprot [(AXI_NTPA_INDEX * 3) +: 3]),
    .axi_arready  (m_axi_arready[(AXI_NTPA_INDEX * 1) +: 1]),
    .axi_arvalid  (m_axi_arvalid[(AXI_NTPA_INDEX * 1) +: 1]),
    .axi_awaddr   (m_axi_awaddr [(AXI_NTPA_INDEX * 32) +: 5]),
    .axi_awprot   (m_axi_awprot [(AXI_NTPA_INDEX * 3) +: 3]),
    .axi_awready  (m_axi_awready[(AXI_NTPA_INDEX * 1) +: 1]),
    .axi_awvalid  (m_axi_awvalid[(AXI_NTPA_INDEX * 1) +: 1]),
    .axi_bready   (m_axi_bready [(AXI_NTPA_INDEX * 1) +: 1]),
    .axi_bresp    (m_axi_bresp  [(AXI_NTPA_INDEX * 2) +: 2]),
    .axi_bvalid   (m_axi_bvalid [(AXI_NTPA_INDEX * 1) +: 1]),
    .axi_rdata    (m_axi_rdata  [(AXI_NTPA_INDEX * 32) +: 32]),
    .axi_rready   (m_axi_rready [(AXI_NTPA_INDEX * 1) +: 1]),
    .axi_rresp    (m_axi_rresp  [(AXI_NTPA_INDEX * 2) +: 2]),
    .axi_rvalid   (m_axi_rvalid [(AXI_NTPA_INDEX * 1) +: 1]),
    .axi_wdata    (m_axi_wdata  [(AXI_NTPA_INDEX * 32) +: 32]),
    .axi_wready   (m_axi_wready [(AXI_NTPA_INDEX * 1) +: 1]),
    .axi_wstrb    (m_axi_wstrb  [(AXI_NTPA_INDEX * 32/8) +: 32/8]),
    .axi_wvalid   (m_axi_wvalid [(AXI_NTPA_INDEX * 1) +: 1]),
    .PPS_IN_N     (PPS_INA_N),
    .PPS_IN_P     (PPS_INA_P),
    .PPS_OUT      (PPS_OUTA),
    .TEN_MHZ_IN_N (TEN_MHZ_INA_N),
    .TEN_MHZ_IN_P (TEN_MHZ_INA_P),
    .TEN_MHZ_OUT  (TEN_MHZ_OUTA),
    .PLL_locked   (PLL_LOCKEDA),
    .NTP_TIME     (NTP_TIMEA),
    .NTP_TIME_UPD (NTP_TIMEA_UPD),
    .LED1         (NTP_LED1A),
    .LED2         (NTP_LED2A),
    .SYNC_OK      (SYNC_OKA)
    );


  ntp_clock_top ntp_clock_topB (
    .reset        (reset),
    .axi_aclk     (axi_aclk),
    .axi_aresetn  (axi_aresetn),
    .axi_araddr   (m_axi_araddr [(AXI_NTPB_INDEX * 32) +: 5]),
    .axi_arprot   (m_axi_arprot [(AXI_NTPB_INDEX * 3) +: 3]),
    .axi_arready  (m_axi_arready[(AXI_NTPB_INDEX * 1) +: 1]),
    .axi_arvalid  (m_axi_arvalid[(AXI_NTPB_INDEX * 1) +: 1]),
    .axi_awaddr   (m_axi_awaddr [(AXI_NTPB_INDEX * 32) +: 5]),
    .axi_awprot   (m_axi_awprot [(AXI_NTPB_INDEX * 3) +: 3]),
    .axi_awready  (m_axi_awready[(AXI_NTPB_INDEX * 1) +: 1]),
    .axi_awvalid  (m_axi_awvalid[(AXI_NTPB_INDEX * 1) +: 1]),
    .axi_bready   (m_axi_bready [(AXI_NTPB_INDEX * 1) +: 1]),
    .axi_bresp    (m_axi_bresp  [(AXI_NTPB_INDEX * 2) +: 2]),
    .axi_bvalid   (m_axi_bvalid [(AXI_NTPB_INDEX * 1) +: 1]),
    .axi_rdata    (m_axi_rdata  [(AXI_NTPB_INDEX * 32) +: 32]),
    .axi_rready   (m_axi_rready [(AXI_NTPB_INDEX * 1) +: 1]),
    .axi_rresp    (m_axi_rresp  [(AXI_NTPB_INDEX * 2) +: 2]),
    .axi_rvalid   (m_axi_rvalid [(AXI_NTPB_INDEX * 1) +: 1]),
    .axi_wdata    (m_axi_wdata  [(AXI_NTPB_INDEX * 32) +: 32]),
    .axi_wready   (m_axi_wready [(AXI_NTPB_INDEX * 1) +: 1]),
    .axi_wstrb    (m_axi_wstrb  [(AXI_NTPB_INDEX * 32/8) +: 32/8]),
    .axi_wvalid   (m_axi_wvalid [(AXI_NTPB_INDEX * 1) +: 1]),
    .PPS_IN_N     (PPS_INB_N),
    .PPS_IN_P     (PPS_INB_P),
    .PPS_OUT      (PPS_OUTB),
    .TEN_MHZ_IN_N (TEN_MHZ_INB_N),
    .TEN_MHZ_IN_P (TEN_MHZ_INB_P),
    .TEN_MHZ_OUT  (TEN_MHZ_OUTB),
    .PLL_locked   (PLL_LOCKEDB),
    .NTP_TIME     (NTP_TIMEB),
    .NTP_TIME_UPD (NTP_TIMEB_UPD),
    .LED1         (NTP_LED1B),
    .LED2         (NTP_LED2B),
    .SYNC_OK      (SYNC_OKB)
    );

endmodule // ntps_interfaces

`default_nettype wire

//======================================================================
// EOF ntps_interfaces.v
//======================================================================
