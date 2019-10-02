# Test config for Capgemini and Seadrill

## Install

Open Cloud Shell.

```bash
git clone https://github.com/richeney/seadrill
cd seadrill
rm -fR .git
```

Edit the terraform.tfvars file to override the default values.

Set the defaults for your CLI to match, e.g.:

```bash
az configure --defaults group=seadrill location=westeurope
```

> You can unset these later with `az configure --defaults group=seadrill location=westeurope`

## Run Terraform to provision the config.

```bash
terraform init
terraform plan
terraform apply
```

Go and make a coffee. Rerun the `terraform apply` if there are errors as I haven't added in sufficient deployment controls such as dependencies.

## IP Addresses

List out the IP addresses and put them into a text file for reference.

```bash
az vm list-ip-addresses --output table
az network public-ip show --name seadrill-fw-pip --output table
```

## Test

1. SSH to the firewall's public IP

    ```bash
    ssh overlord@<Public IP address for the firewall>
    ```

    This is using the firewall NAT rule to get through to vm1. This vm is in spoke1 and does not have a public IP.

    All VMs have overlord as the admin ID and `BarefacedOne10!` as the password.

1. Check that vm1 can reach the internet

    ```bash
    curl https://www.bbc.co.uk
    ```

1. Check that you can get to vm2 from vm1

    ```bash
    ssh overlord@10.2.1.4
    ```

    Your internal IP address for vm2 may be different. This is using the peers, and UDRs hitting the firewall, which is then routing to spoke2.

    Successfully SSHing across is the same as a VM in one of the spokes accessing the shared support services vNet or AD vNet.

1. Check that vm2 can also see the BBC website.

    ```bash
    curl https://www.bbc.co.uk
    ```
