#!/bin/bash

# ++ +++ +++++++ # ++++++++ +++++++ # ++++++ +++++++++ # ++++++++++ +++++++ ++ #
# ++ --- ------- # -------- ------- # ------ --------- # ---------- ------- ++ #
# ++                                                                        ++ #
# ++  Set up SSH tunnels to the places that you want to go to.              ++ #
# ++                                                                        ++ #
# ++ --- ------- # -------- ------- # ------ --------- # ---------- ------- ++ #
# ++ +++ +++++++ # ++++++++ +++++++ # ++++++ +++++++++ # ++++++++++ +++++++ ++ #


echo "" ; echo "" ;
echo "### ################################################# ###"
echo "### Tunnels created on $(date)."
echo "### ################################################# ###"
echo ""

ssh -N azure-gitlab &
ssh -N azure-jenkins &
ssh -N azure-kibana &
ssh -N azure-nexus &
ssh -N azure-sonar &
ssh -N azure-registry &
ssh -N app3-kibana &
ssh -N app5-kibana &
ssh -N app7-kibana &

echo ""
echo "### Tunnel creation has completed on $(date)."
echo "### =================================================== ###"
echo ""

