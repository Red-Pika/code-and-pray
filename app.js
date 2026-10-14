const SHAPES = {
  aws: [
    { id: "t3.micro", cpu: 2, ram: 1, family: "burstable" },
    { id: "t3.small", cpu: 2, ram: 2, family: "burstable" },
    { id: "t3.medium", cpu: 2, ram: 4, family: "burstable" },
    { id: "m5.large", cpu: 2, ram: 8, family: "general" },
    { id: "m5.xlarge", cpu: 4, ram: 16, family: "general" },
    { id: "c5.xlarge", cpu: 4, ram: 8, family: "compute" },
    { id: "r5.large", cpu: 2, ram: 16, family: "memory" },
  ],
  azure: [
    { id: "Standard_B1s", cpu: 1, ram: 1, family: "burstable" },
    { id: "Standard_B2s", cpu: 2, ram: 4, family: "burstable" },
    { id: "Standard_D2s_v3", cpu: 2, ram: 8, family: "general" },
    { id: "Standard_D4s_v3", cpu: 4, ram: 16, family: "general" },
    { id: "Standard_F4s_v2", cpu: 4, ram: 8, family: "compute" },
    { id: "Standard_E2s_v3", cpu: 2, ram: 16, family: "memory" },
  ],
  gcp: [
    { id: "e2-micro", cpu: 2, ram: 1, family: "burstable" },
    { id: "e2-small", cpu: 2, ram: 2, family: "burstable" },
    { id: "e2-medium", cpu: 2, ram: 4, family: "burstable" },
    { id: "n2-standard-2", cpu: 2, ram: 8, family: "general" },
    { id: "n2-standard-4", cpu: 4, ram: 16, family: "general" },
    { id: "n2-highcpu-4", cpu: 4, ram: 4, family: "compute" },
    { id: "n2-highmem-2", cpu: 2, ram: 16, family: "memory" },
  ],
};

const DISKS = {
  aws: [
    { id: "gp3", label: "gp3 (SSD)" },
    { id: "gp2", label: "gp2 (SSD)" },
    { id: "io2", label: "io2 (provisioned IOPS)" },
  ],
  azure: [
    { id: "Premium_LRS", label: "Premium SSD" },
    { id: "StandardSSD_LRS", label: "Standard SSD" },
    { id: "Standard_LRS", label: "Standard HDD" },
  ],
  gcp: [
    { id: "pd-balanced", label: "pd-balanced" },
    { id: "pd-ssd", label: "pd-ssd" },
    { id: "pd-standard", label: "pd-standard" },
  ],
};

const REGIONS = {
  aws: ["ap-southeast-1", "ap-southeast-3", "us-east-1", "eu-west-1"],
  azure: ["Southeast Asia", "Indonesia Central", "East US", "West Europe"],
  gcp: ["asia-southeast1", "asia-southeast2", "us-central1", "europe-west1"],
};

const NAMES = {
  aws: { vm: "aws_instance", asg: "aws_autoscaling_group", size: "instance_type", disk: "root_block_device", tmpl: "aws_launch_template" },
  azure: { vm: "azurerm_linux_virtual_machine", asg: "azurerm_linux_virtual_machine_scale_set", size: "size / sku", disk: "os_disk", tmpl: "inline on the scale set" },
  gcp: { vm: "google_compute_instance", asg: "google_compute_instance_group_manager", size: "machine_type", disk: "boot_disk", tmpl: "google_compute_instance_template" },
};

const $ = (id) => document.getElementById(id);

const state = {
  cloud: "aws",
  mode: "vm",
};

function selectedShape() {
  return SHAPES[state.cloud].find((s) => s.id === $("shape").value) || SHAPES[state.cloud][2];
}

function lifecycleBlock(indent = "  ") {
  const lines = [];
  if ($("cbd").checked) lines.push(`${indent}  create_before_destroy = true`);
  if ($("prevent").checked) lines.push(`${indent}  prevent_destroy       = true`);
  if ($("ignore-ami").checked) {
    const attr = state.cloud === "aws" ? "ami" : state.cloud === "azure" ? "source_image_reference" : "boot_disk";
    lines.push(`${indent}  ignore_changes         = [${attr}]`);
  }
  if (!lines.length) return "";
  return `\n${indent}lifecycle {\n${lines.join("\n")}\n${indent}}\n`;
}

function awsHcl() {
  const shape = selectedShape();
  const disk = $("disk").value;
  const dtype = $("disk-type").value;
  const region = $("region").value;
  const lc = lifecycleBlock();

  if (state.mode === "vm") {
    return `terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" {
  region = "${region}"
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "app" {
  ami           = data.aws_ami.al2023.id
  instance_type = "${shape.id}"

  root_block_device {
    volume_size = ${disk}
    volume_type = "${dtype}"
  }

  tags = { Name = "app" }
${lc}}`;
  }

  return `terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" {
  region = "${region}"
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_launch_template" "app" {
  name_prefix   = "app-"
  image_id      = data.aws_ami.al2023.id
  instance_type = "${shape.id}"

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = ${disk}
      volume_type = "${dtype}"
    }
  }
${lc}}

resource "aws_autoscaling_group" "app" {
  name                      = "app-asg"
  min_size                  = ${$("min").value}
  desired_capacity          = ${$("desired").value}
  max_size                  = ${$("max").value}
  health_check_type         = "EC2"
  vpc_zone_identifier       = var.subnet_ids

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
  }
}

resource "aws_autoscaling_policy" "cpu" {
  name                   = "target-cpu"
  autoscaling_group_name = aws_autoscaling_group.app.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = ${$("cpu").value}
  }
}`;
}

function azureHcl() {
  const shape = selectedShape();
  const disk = $("disk").value;
  const dtype = $("disk-type").value;
  const region = $("region").value;
  const lc = lifecycleBlock();

  const image = `  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }`;

  if (state.mode === "vm") {
    return `terraform {
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 4.0" }
  }
}

provider "azurerm" { features {} }

resource "azurerm_resource_group" "app" {
  name     = "rg-app"
  location = "${region}"
}

resource "azurerm_linux_virtual_machine" "app" {
  name                  = "app-vm"
  resource_group_name   = azurerm_resource_group.app.name
  location              = azurerm_resource_group.app.location
  size                  = "${shape.id}"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.app.id]
  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_public_key
  }

${image}

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "${dtype}"
    disk_size_gb         = ${disk}
  }
${lc}}`;
  }

  return `terraform {
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 4.0" }
  }
}

provider "azurerm" { features {} }

resource "azurerm_resource_group" "app" {
  name     = "rg-app"
  location = "${region}"
}

resource "azurerm_linux_virtual_machine_scale_set" "app" {
  name                = "app-vmss"
  resource_group_name = azurerm_resource_group.app.name
  location            = azurerm_resource_group.app.location
  sku                 = "${shape.id}"
  instances           = ${$("desired").value}
  admin_username      = "azureuser"
  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_public_key
  }

${image}

  os_disk {
    storage_account_type = "${dtype}"
    caching              = "ReadWrite"
    disk_size_gb         = ${disk}
  }

  network_interface {
    name    = "nic"
    primary = true
    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = var.subnet_id
    }
  }
${lc}}

resource "azurerm_monitor_autoscale_setting" "app" {
  name                = "app-autoscale"
  resource_group_name = azurerm_resource_group.app.name
  location            = azurerm_resource_group.app.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.app.id

  profile {
    name = "default"
    capacity {
      minimum = "${$("min").value}"
      default = "${$("desired").value}"
      maximum = "${$("max").value}"
    }
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.app.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = ${$("cpu").value}
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }
}`;
}

function gcpHcl() {
  const shape = selectedShape();
  const disk = $("disk").value;
  const dtype = $("disk-type").value;
  const region = $("region").value;
  const zone = `${region}-a`;
  const lc = lifecycleBlock();

  if (state.mode === "vm") {
    return `terraform {
  required_providers {
    google = { source = "hashicorp/google", version = "~> 6.0" }
  }
}

provider "google" {
  project = var.project_id
  region  = "${region}"
}

resource "google_compute_instance" "app" {
  name         = "app-vm"
  machine_type = "${shape.id}"
  zone         = "${zone}"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = ${disk}
      type  = "${dtype}"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
${lc}}`;
  }

  return `terraform {
  required_providers {
    google = { source = "hashicorp/google", version = "~> 6.0" }
  }
}

provider "google" {
  project = var.project_id
  region  = "${region}"
}

resource "google_compute_instance_template" "app" {
  name_prefix  = "app-"
  machine_type = "${shape.id}"

  disk {
    source_image = "debian-cloud/debian-12"
    disk_size_gb = ${disk}
    disk_type    = "${dtype}"
    boot         = true
  }

  network_interface {
    network = "default"
  }
${lc}}

resource "google_compute_region_instance_group_manager" "app" {
  name               = "app-mig"
  base_instance_name = "app"
  region             = "${region}"
  target_size        = ${$("desired").value}

  version {
    instance_template = google_compute_instance_template.app.id
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.app.id
    initial_delay_sec = 60
  }
}

resource "google_compute_region_autoscaler" "app" {
  name   = "app-autoscaler"
  region = "${region}"
  target = google_compute_region_instance_group_manager.app.id

  autoscaling_policy {
    min_replicas = ${$("min").value}
    max_replicas = ${$("max").value}
    cpu_utilization { target = ${($("cpu").value / 100).toFixed(2)} }
  }
}`;
}

function fillSelect(el, items, map) {
  const current = el.value;
  el.innerHTML = items.map(map).join("");
  if ([...el.options].some((o) => o.value === current)) el.value = current;
}

function syncSelectors() {
  const cloud = state.cloud === "compare" ? "aws" : state.cloud;
  fillSelect($("shape"), SHAPES[cloud], (s) => `<option value="${s.id}">${s.id} · ${s.cpu} vCPU · ${s.ram} GiB · ${s.family}</option>`);
  fillSelect($("disk-type"), DISKS[cloud], (d) => `<option value="${d.id}">${d.label}</option>`);
  fillSelect($("region"), REGIONS[cloud], (r) => `<option value="${r}">${r}</option>`);
}

function renderDiagram() {
  const cloud = state.cloud;
  const shape = selectedShape();
  const names = NAMES[cloud];
  const disk = $("disk").value;
  const dtype = $("disk-type").value;

  $("diagram-title").textContent = state.mode === "vm" ? "Single VM" : "Autoscaling group";
  $("diagram-hint").textContent =
    state.mode === "vm"
      ? `${names.vm} is the unit Terraform tracks. Stop/start is a cloud action; destroy is a Terraform action.`
      : `Terraform tracks the group (${names.asg}), not each member. Members come and go as capacity and health change.`;

  if (state.mode === "vm") {
    $("machine").innerHTML = `
      <div class="node accent"><strong>${names.vm}</strong><span>resource</span></div>
      <div class="node"><strong>${names.size}</strong><span>${shape.id}</span></div>
      <div class="node"><strong>${shape.cpu} vCPU</strong><span>${shape.ram} GiB RAM</span></div>
      <div class="node"><strong>${names.disk}</strong><span>${disk} GB · ${dtype}</span></div>`;
  } else {
    $("machine").innerHTML = `
      <div class="node"><strong>${names.tmpl}</strong><span>blueprint</span></div>
      <div class="node accent"><strong>${names.asg}</strong><span>min ${$("min").value} / want ${$("desired").value} / max ${$("max").value}</span></div>
      <div class="node"><strong>${shape.id}</strong><span>${shape.cpu} vCPU · ${shape.ram} GiB</span></div>
      <div class="node"><strong>CPU ${$("cpu").value}%</strong><span>scale trigger</span></div>`;
  }

  const vmStates = ["pending", "running", "stopping", "stopped", "terminated"];
  const asgStates = ["launching", "healthy", "scale-out", "replacing", "scale-in"];
  const list = state.mode === "vm" ? vmStates : asgStates;
  const now = state.mode === "vm" ? "running" : "healthy";
  $("states").innerHTML = list
    .map((s) => `<span class="state ${s === now ? "now" : ""} ${s === "terminated" || s === "replacing" ? "force" : ""}">${s}</span>`)
    .join("");

  const replace = [];
  if (state.mode === "vm") {
    replace.push("Changing image/AMI or many network fields usually forces a new instance.");
    if (cloud === "aws") replace.push("instance_type can often update in place; an AMI change is a replace.");
    if (cloud === "azure") replace.push("size can resize in place when the series allows it; image SKU changes replace the VM.");
    if (cloud === "gcp") replace.push("machine_type can update with stop/start; changing boot image creates a new instance.");
  } else {
    replace.push("Change the template, then roll: ASG instance refresh, VMSS rolling upgrade, MIG new version.");
    replace.push("create_before_destroy on the template needs a name_prefix so the new template can exist beside the old one.");
  }
  if ($("prevent").checked) replace.push("prevent_destroy will make terraform destroy fail until you remove the flag.");
  $("apply-insight").textContent = replace.join(" ");
}

function renderNotes() {
  const cloud = state.cloud;
  const n = NAMES[cloud];
  const bits = [
    `<p><strong>Size field:</strong> ${n.size}. Same idea everywhere — pick a SKU that encodes vCPU and RAM. Disk is separate.</p>`,
    `<ul>
      <li><strong>Create</strong> — <code>terraform apply</code> inserts ${state.mode === "vm" ? n.vm : n.asg}.</li>
      <li><strong>Update in place</strong> — tags, some disk size increases, ASG min/max.</li>
      <li><strong>Replace</strong> — new physical VM. Use ${$("cbd").checked ? "create_before_destroy (already on)" : "create_before_destroy"} to avoid a gap.</li>
      <li><strong>Stop ≠ destroy</strong> — stopped VMs still exist in state. Destroy removes the resource.</li>
    </ul>`,
  ];
  if (state.mode === "asg") {
    bits.push(
      `<p>Autoscaling is three pieces: a <strong>template</strong> (${n.tmpl}), a <strong>group</strong> (${n.asg}), and a <strong>policy</strong> that moves desired capacity.</p>`
    );
  }
  $("notes").innerHTML = bits.join("");
}

function renderHcl() {
  const fn = { aws: awsHcl, azure: azureHcl, gcp: gcpHcl }[state.cloud];
  $("hcl").textContent = fn();
}

function renderCompare() {
  const rows = [
    ["VM resource", "aws_instance", "azurerm_linux_virtual_machine", "google_compute_instance"],
    ["Size argument", "instance_type", "size (VM) / sku (VMSS)", "machine_type"],
    ["OS disk", "root_block_device / ebs", "os_disk", "boot_disk / initialize_params"],
    ["Image", "ami / aws_ami data", "source_image_reference", "source image on disk"],
    ["ASG", "aws_autoscaling_group", "azurerm_linux_virtual_machine_scale_set", "google_compute_*_instance_group_manager"],
    ["Launch blueprint", "aws_launch_template", "fields on the scale set", "google_compute_instance_template"],
    ["Scale policy", "aws_autoscaling_policy", "azurerm_monitor_autoscale_setting", "google_compute_region_autoscaler"],
    ["Rolling replace", "instance_refresh", "upgrade_policy / rolling", "MIG version + update_policy"],
    ["Lifecycle flags", "lifecycle {} on instance/template", "lifecycle {} on VM/VMSS", "lifecycle {} on instance/template"],
    ["Stop vs destroy", "stop_instance API; resource remains", "deallocate; resource remains", "stop; resource remains"],
  ];
  $("compare-body").innerHTML = rows
    .map((r) => `<tr>${r.map((c) => `<td>${c}</td>`).join("")}</tr>`)
    .join("");
  $("compare-notes").innerHTML = `
    <p>Read one row at a time. The <em>intent</em> is identical: a sized machine, a disk, optionally a group that grows and heals. Only the resource names change.</p>
    <p>Use a launch template / instance template whenever you autoscale. Putting size and image on the group itself makes rolling replacements harder.</p>`;
}

function render() {
  document.body.dataset.cloud = state.cloud;
  document.body.dataset.mode = state.mode;
  const comparing = state.cloud === "compare";
  $("main-grid").hidden = comparing;
  $("intent-panel").hidden = comparing;
  $("lifecycle-controls").hidden = comparing;
  $("compare-view").hidden = !comparing;
  if (comparing) {
    renderCompare();
    return;
  }
  $("disk-label").textContent = `${$("disk").value} GB`;
  renderDiagram();
  renderNotes();
  renderHcl();
}

function bind() {
  document.querySelectorAll(".cloud").forEach((btn) => {
    btn.addEventListener("click", () => {
      state.cloud = btn.dataset.cloud;
      document.querySelectorAll(".cloud").forEach((b) => b.setAttribute("aria-selected", String(b === btn)));
      if (state.cloud !== "compare") syncSelectors();
      render();
    });
  });
  $("mode").addEventListener("change", () => {
    state.mode = $("mode").value;
    render();
  });
  ["shape", "disk", "disk-type", "region", "cbd", "prevent", "ignore-ami", "min", "desired", "max", "cpu"].forEach((id) => {
    $(id).addEventListener("input", render);
    $(id).addEventListener("change", render);
  });
  $("copy").addEventListener("click", async () => {
    await navigator.clipboard.writeText($("hcl").textContent);
    $("copy").textContent = "Copied";
    setTimeout(() => {
      $("copy").textContent = "Copy";
    }, 1200);
  });
}

syncSelectors();
bind();
render();
