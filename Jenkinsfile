#!groovy

def artServer = Artifactory.server "onsart-01"
def buildInfo = Artifactory.newBuildInfo()
def agentRVersion = 'r_4.4'


def pushToArtifactoryRepo(String packagePath = 'dist/*.tar.gz', String artifactoryHost = 'onsart-01.ons.statistics.gov.uk') {
  withCredentials([usernamePassword(credentialsId: env.ARTIFACTORY_CREDS, usernameVariable: 'ARTIFACTORY_USER', passwordVariable: 'ARTIFACTORY_PASSWORD')]) {
    sh "curl -u ${ARTIFACTORY_USER}:\\${ARTIFACTORY_PASSWORD} -T ${packagePath} 'https://${artifactoryHost}/artifactory/${env.ARTIFACTORY_R_REPO}/'"
  }
}

pipeline {
  libraries {
    lib('jenkins-pipeline-shared')
  }
  environment {
    PROJECT_NAME = "rsurveymethods"
    MAIN_BRANCH = "main"
    PROXY = credentials("PROXY")
    ARTIFACTORY_CREDS = "ARTIFACTORY_CREDENTIALS"
    ARTIFACTORY_R_REPO = "LR_rsurveymethods"
    BUILD_BRANCH = "jenkins"
    BUILD_TAG = "v*.*.*"
  }
  options {
    skipDefaultCheckout true
  }
  agent any

  stages {

    stage('List Agent Labels') {
      steps {
        script {
          def labels = Jenkins.instance.getLabelAtoms()*.name
            println "Available agent labels:"
            labels.each { label ->
            println " - ${label}"
          }
        }
      }
    }

    stage("Checkout") {
      agent { label "download.jenkins.slave" }
      steps {
        colourText("info", "Checking out code from source control.")
        checkout scm
        script {
          buildInfo.name = "${PROJECT_NAME}"
          buildInfo.number = "${BUILD_NUMBER}"
          buildInfo.env.collect()
        }
        stash name: "Checkout", useDefaultExcludes: false
      }
    }

    stage("Build") {
      agent { label "build.${agentRVersion}" }
      steps {
        unstash name: 'Checkout'
        colourText('info', "Building R package")
        sh '''
          mkdir -p dist
          R CMD build . --no-build-vignettes --no-manual --output=dist
        '''

        stash name: "Build", useDefaultExcludes: false
      }
    }

    stage("Deploy") {
      when {
        anyOf {
          branch BUILD_BRANCH
          tag BUILD_TAG
        }
        beforeAgent true
      }
      agent { label "deploy.jenkins.slave" }
      steps {
        unstash name: "Build"
        colourText('info', "Deploying to Artifactory")
        pushToArtifactoryRepo()
      }
    }
  }
}
