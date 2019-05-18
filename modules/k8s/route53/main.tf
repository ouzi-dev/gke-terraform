provider "aws" {
  region     = "${var.aws_region}"
}

data "aws_route53_zone" "main_hosted_zone" {
  name  = "${var.main_hosted_zone}."
}

resource "aws_route53_zone" "ingress_hosted_zone" {
  name = "${var.cluster_name}.${var.main_hosted_zone}"

  tags {
      Cluster = "${var.cluster_name}"
  }
}

resource "aws_route53_record" "ingress_ns" {
  zone_id = "${data.aws_route53_zone.main_hosted_zone.zone_id}"
  name    = "${aws_route53_zone.ingress_hosted_zone.name}"
  type    = "NS"
  ttl     = "${var.hosted_zone_ttl}"

  records = [
    "${aws_route53_zone.ingress_hosted_zone.name_servers.0}",
    "${aws_route53_zone.ingress_hosted_zone.name_servers.1}",
    "${aws_route53_zone.ingress_hosted_zone.name_servers.2}",
    "${aws_route53_zone.ingress_hosted_zone.name_servers.3}",
  ]
}

resource "aws_iam_user" "route53_user" {
  name = "${var.cluster_name}_route53_user"
}

resource "aws_iam_policy" "route53_policy" {
  name        = "${var.cluster_name}_route53_policy"
  description = "Policy for route53 ${var.cluster_name}"
  policy      = <<POLICY
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Effect": "Allow",
     "Action": [
       "route53:GetChange"
     ],
     "Resource": [
       "arn:aws:route53:::change/*"
     ]
   },
   {
     "Effect": "Allow",
     "Action": [
       "route53:ChangeResourceRecordSets"
     ],
     "Resource": [
       "arn:aws:route53:::hostedzone/${aws_route53_zone.ingress_hosted_zone.zone_id}"
     ]
   },
   {
     "Effect": "Allow",
     "Action": [
       "route53:ListHostedZones",
       "route53:ListResourceRecordSets",
       "route53:ListHostedZonesByName"
     ],
     "Resource": [
       "*"
     ]
   }
 ]
}
POLICY
}

resource "aws_iam_user_policy_attachment" "route53_policy_attach" {
  user       = "${aws_iam_user.route53_user.name}"
  policy_arn = "${aws_iam_policy.route53_policy.arn}"
}

resource "aws_iam_access_key" "route53_access_key" {
  user    = "${aws_iam_user.route53_user.name}"
}