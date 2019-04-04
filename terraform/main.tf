provider "aws"{
    region ="${var.aws_region}"
    version = "~> 1.19"
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
}


resource "aws_instance" "web-server" {
  ami = "ami-007d5db58754fa284"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.web-node.name}"]
  count = "${var.instance_count}"
  
  key_name = "terraform"
  tags {
    Name = "web-instance"
  }

  connection {
    type     = "ssh"
    user     = "ubuntu"
    agent = true
  }
  provisioner "remote-exec" {
    inline=[
        "apt-get update",
        "apt-get -y install nginx",
        "systemctl restart nginx"
        ]
    }
    
}


resource "aws_elb" "web" {
  name = "web-elb"

  security_groups = ["${aws_security_group.elb.id}"]
  availability_zones = "${var.aws_available_region}"

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  # The instance is registered automatically

  instances                   = ["${aws_instance.web-server.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}
