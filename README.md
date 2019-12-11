# Gitea on Kubernetes

## 配置项
需提供以下配置项

- GITEA_WORK_DIR  工作目录的绝对路径，默认为/data，需挂载volume到此路径
- USER            Gitea 运行时使用的系统用户，它将作为一些 repository 的访问地址的一部分，默认使用 git
- CONFIG          Gitea 主配置文件，将复制为 $GITEA_WORK_DIR/custom/conf/app.ini
- CRON            备份计划任务
- RETAIN          备份保留天数
- NOTIFYAPI       邮件接口
- TOS             邮件接收人


## SSH代理
通过 ingress nginx 代理 ssh

```yaml
kind: ConfigMap
apiVersion: v1
metadata:
  name: tcp-services
  namespace: intra
data:
  222: "intra/git:2222"
```

大于 2000 的端口可能会被占用，导致监听失败，所以使用 三位数 端口来转发到 git 2222 端口（使用git账号运行gitea，无权限监听三位数端口）

## 初始化

使用命令行添加管理员, 用户名不能为 `admin`

```bash
/gitea --work-path /data --custom-path /data/custom --config /data/custom/conf/app.ini admin create-user --username root --password admin19 --email=example@qq.com --admin
```

## 数据安全

`pv` 回收策略改为 `Retain`

```bash
kubectl patch pv pvc-6782347e-cfa9-11e9-9dbf-e8631f143422 -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}'
```

### 使用脚本定时备份

配置 CRON

```yaml
RETAIN: 30  # 本地备份保留天数
CRON: |
  0 2 * * * /dump.sh &>/tmp/gitea-dump.sh
```

### 备份上传到 minio 

Todo

